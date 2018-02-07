### Setup instructions
Install mongoDB

Pull the project and run `bundle install` in order to install all the dependencies.

Make sure you use >= ruby 2.1 in order for the keyword-arguments and potentially some other features worked as expected on your computer.

Before running any script, make sure your mongo deamon is up: `mongod` in a console if the bin path was added to the PATH, otherwise ./path-to-your-installation/mongod. This should boot a ready-to-listen mongo server

### Usage instructions
1. In order to create database records, in the project root directory run:
```
rake seed_database
```

2. Now you are free to experiment

*For a single/bunch of dates you would:
```
rspec regular_exchange_amount[amount,currency,dates]
```

__Example:__ `rake regular_exchange_amount[100,'dollar','2018-01-25']`. To perform the task for a  collection of dates, specify them as such: '2018-01-25 2017-03-04 etc'

*Alternatively, you can exchange the amount for a collection of dates by specifying a single date+an offset:
```
rake date_offset_exchange_amount[amount,currency,date,offset,since_or_until]
```
__Example:__ rake date_offset_exchange_amount[100,'euro','2018-01-25',2,'until']
__Note:__ avoid spaces between arguments passed to the rake task! you can toggle 'until'/'since'. Some of the date reports are missing, so it will silently skip the suggested date and return a result for those matched

