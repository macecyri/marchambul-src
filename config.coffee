module.exports =
  API_URL: 'http://localhost:5000/api/v1'
  FRONT_URL: 'http://localhost:3000'
  ASSETS_URL: 'http://localhost:5000'

  preprod:
    API_URL: 'http://weegid-preprod.herokuapp.com/api/v1'
    FRONT_URL: 'http://weegid-preprod.herokuapp.com'
    ASSETS_URL: '//app.preprod.weegid.com.s3-eu-west-1.amazonaws.com'

  prod:
    API_URL: 'http://app.weegid.com/api/v1'
    FRONT_URL: 'http://app.weegid.com'
    ASSETS_URL: '//app.weegid.com.s3-eu-west-1.amazonaws.com'
