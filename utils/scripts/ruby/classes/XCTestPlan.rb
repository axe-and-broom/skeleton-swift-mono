require 'securerandom'

def generate_uuid
  SecureRandom.uuid.upcase
end

class XCTestPlanConfiguration
  def initialize(
      id = generate_uuid, 
      name = "Default", 
      language = "en",
      region = "SE"
    )
    @id = id
    @name = name
    @language = language
    @region = region
  end

  def id
    @id
  end

  def name
    @name
  end

  def language
    @language
  end

  def region
    @region
  end

  def to_object
    {
      'id' => @id,
      'name' => @name,
      'options' => {
        'language' => @language,
        'region' => @region
      }
    }
  end
end

class XCTestPlanTestTarget
  def initialize(
      container_path, 
      identifier, 
      enabled = true, 
      parallelizable = false
    )
    @container_path = container_path
    @identifier = identifier
    @enabled = enabled
    @parallelizable = parallelizable
  end

  def container_path
    @container_path
  end

  def identifier
    @identifier
  end

  def name
    @identifier
  end

  def enabled
    @enabled
  end

  def parallelizable
    @parallelizable
  end

  def to_object
    {
      'enabled' => @enabled,
      'parallelizable' => @parallelizable,
      'target' => {
        'containerPath' => "container:#{@container_path}",
        'identifier' => @identifier,
        'name' => @identifier
      }
    }
  end
end

class XCTestPlan
  def initialize(
      name, 
      container_path, 
      test_targets, 
      environment_variables = {}, 
      configurations = [XCTestPlanConfiguration.new()]
    )
    @name = name
    @container_path = container_path
    @test_targets = test_targets
    @environment_variables = environment_variables
    @configurations = configurations
  end

  def name
    @name
  end

  def test_targets
    @test_targets
  end

  def environment_variables
    @environment_variables
  end

  def configurations
    @configurations
  end

  def to_object
    environment_variables = @environment_variables.map{ |key, value|
      {
        'key' => key,
        'value' => value
      }
    }

    test_targets = @test_targets.map{ |test_target|
      test_target.to_object
    }

    configurations = @configurations.map{ |configuration|
      configuration.to_object
    }

    {
      'configurations' => configurations,
      'defaultOptions' => {
        'environmentVariableEntries' => environment_variables,
        'targetForVariableExpansion' => {
          'containerPath' => "container:#{@container_path}",
          'identifier' => generate_uuid(),
          'name' => @name
        },
        'testExecutionOrdering' => 'random',
        'testRepetitionMode' => 'fixedIterations',
        'testTimeoutsEnabled' => true
      },
      'testTargets' => test_targets,
      'version' => 1
    }
  end

end
