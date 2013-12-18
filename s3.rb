#!/usr/bin/env ruby

# chmod +x s3.rb
# => modify permissions first

# ./s3.rb 
# => runs file

# ./s3.rb help
# => Help message

# AWS Ruby SDK DOCS: 
# http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html

# ========================================================
# EXAMPLES
# ========================================================
## Find an S3 bucket:
#
# > ./s3.rb bucket my-awesome-bucket
# > Found the bucket 'my-awesome-bucket' in S3!

## Get the bucket's URL:
#
# > ./s3.rb bucket my-photo-bucket --url
# > Found the bucket 'my-photo-bucket' in S3!
# > http://my-photo-bucket.s3.amazonaws.com/

## Create object in bucket:
# 1st argument is the object key
# 2nd argument is its location locally
#
# > ./s3.rb create_object tree.jpg ~/Desktop/tree.jpg --bucket my-photo-bucket
# > Found the bucket 'my-photo-bucket' in S3!
# > Creating object...
# > Created 'tree.jpg' successfully!
# --------------------------------------------------------
require 'thor'
require 'aws-sdk'

class CLI < Thor
  AWS_ACCESS_KEY_ID = '...access key id...'
  AWS_SECRET_ACCESS_KEY = '...secret access key...'

  S3 = AWS::S3.new(
    :access_key_id => AWS_ACCESS_KEY_ID, 
    :secret_access_key => AWS_SECRET_ACCESS_KEY
  )

  desc 'bucket', 'Sets the S3 bucket'
  method_option :url, :desc => "Displays bucket's url"
  def bucket(name)
    set_bucket(name)
    puts @bucket.url if options[:url]
  end


  desc 'list_buckets', 'List all S3 buckets for your account'
  def list_buckets
    puts "You have #{S3.buckets.count} bucket(s):\n"
    puts S3.buckets.map(&:name)
  end

  desc 'create_object', 'Creates an object in your bucket'
  method_option :bucket, :desc => "Bucket to look for objects"
  def create_object(name, path_to_file)
    set_bucket(options[:bucket])

    puts 'Creating object...'
    
    # create object or retrieve existing one
    obj = @bucket.objects[name]

    # specify the data as a path to a file
    obj.write(Pathname.new(path_to_file))

    puts "Created '#{name}' successfully!" if @bucket.objects[name].exists?
  end


  private


  def set_bucket(name)
    if !name
      exit_program("Please provide a bucket name.")
    else
      @bucket_name = name
      @bucket = find_bucket
    end
  end

  def find_bucket
    bucket = S3.buckets[@bucket_name]

    begin
      if !bucket.exists?
        exit_program("Sorry, the bucket '#{bucket.name}' doesn't exist in S3.")
      else
        puts "Found the bucket '#{bucket.name}' in S3!"

        yield(bucket) if block_given?
        return bucket
      end

      rescue Exception => e
        puts e
    end    
  end

  def exit_program(msg = 'Something went wrong!')
    puts msg
    exit(false)
  end
end

# Off we go!
CLI.start
