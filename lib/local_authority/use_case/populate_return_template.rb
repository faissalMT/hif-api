class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, data:)
    populated_data = @template_gateway.find_by(type: 'hif').layout
    p data[:infrastructure][0][:submissionEstimated]
    p data[:infrastructure][0][:grantEstimated]
    #populated_data = data.dup
    populated_data[:infrastructure][0][:targetSubmission] = data[:infrastructure][0][:submissionEstimated]
    populated_data[:infrastructure][0][:targetGranted] = data[:infrastructure][0][:grantEstimated]
    populated_data[:infrastructure][0][:submissionEstimated] = data[:infrastructure][0][:submissionEstimated]
    populated_data[:infrastructure][0][:grantEstimated] = data[:infrastructure][0][:grantEstimated]

    {
      populated_data: populated_data
    }
  end

  private

  def populate_hash(base, data)
    base.each do |key, value|
      next if data[key].nil?
      base[key] = get_data_value(base, data, key, value)
    end
  end

  def get_data_value(base, data, key, value)
    case base[key]
    when Hash
      populate_hash(value, data[key])
    else
      data[key]
    end
  end
end
