## AWS::S3 Command Line Tool

A simple example of a command line tool with Thor. For learning purposes only - not for actual use.

### Find a bucket in Amazon S3

    $ ./s3.rb bucket my-awesome-bucket
    
result:    
    
    Found the bucket 'my-awesome-bucket' in S3!
    
### Get the bucket's URL

    $ ./s3.rb bucket my-photo-bucket --url
    
result:    
    
    Found the bucket 'my-photo-bucket' in S3!
    http://my-photo-bucket.s3.amazonaws.com/
    
### List all of your buckets

    $ ./s3.rb list_buckets
    
result:

    You have 1 bucket(s):
    my-photo-bucket
    
### Create an object in your bucket

Creates an object named `tree.jpg` found in your desktop.

    $ ./s3.rb create_object tree.jpg ~/Desktop/tree.jpg --bucket my-photo-bucket
    
result:
    
    Found the bucket 'my-photo-bucket' in S3!
    Creating object...
    Created 'tree.jpg' successfully!
    
### List help

    $ ./s3.rb help
    
Result:    
    
    s3.rb bucket          # Finds an S3 bucket (and url with --url)
    s3.rb create_object   # Creates an object in your bucket
    s3.rb help [COMMAND]  # Describe available commands or one specific command
    s3.rb list_buckets    # List all S3 buckets for your account
