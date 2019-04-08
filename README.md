# SmsDigitalChallenge

Gets an image for every keyword and build a collage with all downloaded images. This is my first ruby application... So please do not be so harsh ;))

## Requirements

1. ImageMagick command-line tool has to be installed. You can check if you have it installed by running

    ```sh
    $ convert -version
    Version: ImageMagick 6.8.9-7 Q16 x86_64 2014-09-11 http://www.imagemagick.org
    Copyright: Copyright (C) 1999-2014 ImageMagick Studio LLC
    Features: DPC Modules
    Delegates: bzlib fftw freetype jng jpeg lcms ltdl lzma png tiff xml zlib
    ```

    **Only tested with version 6.8.9.8 !!**

    For Windows you can download here: https://imagemagick.org/download/windows/releases/
    
2. Create an flickr.yml file and pass your flickr key to it
    
    ```
    key: "YOUR KEY"
    secret: "YOUR SECRET"
    ```

## Installation

1. git clone https://github.com/testbuddy/sms_digital_challenge.git
2. cd sms_digital_challenge
3. gem build sms_digital_challenge.gemspec
4. gem install ./sms_digital_challenge-0.1.0.gem

## Usage

Inside the dir sms_digital_challenge call:

```
ruby ./exe/sms_digital_challenge --keywords hallo,test,huhu,interview,bewerbung -o 'ouput.jpg' -y 'flickr.yml'

```

**Important:** the keywords has to be in this form: hallo,test,huhu,interview,bewerbung

Parameter:

```
-k, --keywords a list of keywords; delimiter: ','; default []
-o, --output path to an output jpg file; default: 'output.jpg' inside the folder u call the exe
-d, --dic path to an dic txt file; default: '../dic.txt' inside the gem folder
-y, --flickr path to the flickr.yml
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

