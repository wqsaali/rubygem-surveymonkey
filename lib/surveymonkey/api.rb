require 'surveymonkey/logging'
require 'json'

class Surveymonkey::API
  autoload :Method, 'surveymonkey/api/method'

  # constants

  Api_methods = {
    'create_flow' => {
      'path' => '/v2/batch/create_flow',
    },
    'send_flow' => {
      'path' => '/v2/batch/send_flow',
    },
    'create_collector' => {
      'path' => '/v2/collectors/create_collector',
    },
    'get_survey_list' => {
      'path' => '/v2/surveys/get_survey_list',
    },
    'get_survey_details' => {
      'path' => '/v2/surveys/get_survey_details',
    },
    'get_collector_list' => {
      'path' => '/v2/surveys/get_collector_list',
    },
    'get_respondent_list' => {
      'path' => '/v2/surveys/get_respondent_list',
    },
    'get_responses' => {
      'path' => '/v2/surveys/get_responses',
    },
    'get_response_counts' => {
      'path' => '/v2/surveys/get_response_counts',
    },
    'get_template_list' => {
      'path' => '/v2/templates/get_template_list',
    },
    'get_user_details' => {
      'path' => '/v2/user/get_user_details',
    },
  }

  # public methods
  attr_reader :api_methods

  def api_method(key, api_methods = self.api_methods)
    begin
      $log.debug(sprintf("%s: api methods: %s\n", __method__, api_methods.inspect))
      $log.debug(sprintf("%s: fetching '%s' from API methods\n", __method__, key))
      value = api_methods.fetch(key)
      $log.debug(sprintf("%s: retrieved '%s'\n", __method__, value.inspect))

      path = value['path']
      $log.debug(sprintf("%s: path '%s'\n", __method__, path))
      method = (value['method'] || 'post')
      $log.debug(sprintf("%s: method '%s'\n", __method__, method))

      # return
      Surveymonkey::API::Method.new(path, method)

    rescue KeyError => e
      $log.error(sprintf("%s: '%s' not found in api methods\n", __method__, key))
      raise e
    rescue StandardError => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def api_method_params(method_params)
    begin
      # TODO validate params against API spec
      $log.debug(sprintf("%s: parsing api method params from '%s'\n", __method__, method_params))
      the_params = (method_params.kind_of?(String) ? method_params : JSON.generate(method_params || {}))
      $log.debug(sprintf("%s: parsed method params '%s'\n", __method__, the_params))

      # return
      the_params

    rescue StandardError => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end

  def initialize
    begin
      @api_methods = Api_methods
    rescue StandardError => e
      $log.error(sprintf("%s: %s\n", __method__, e.message))
      raise
    end
  end
end