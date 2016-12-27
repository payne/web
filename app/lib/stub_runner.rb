require_relative '../../lib/fake_disk'

# Each GET/POST is serviced in a new thread which creates a
# new dojo object and thus a new runner object. To ensure
# state is preserved from the setup to the call it has
# to be saved to disk and then retrieved.

class StubRunner

  def initialize(_parent)
    @@disk ||= FakeDisk.new(self)
  end

  def pulled?(image_name); image_names.include?(image_name); end
  def pull(_image_name); end

  # - - - - - - - - - - - - - - - - -

  def new_kata(_image_name, _kata_id); end
  def old_kata(_kata_id); end

  # - - - - - - - - - - - - - - - - -

  def new_avatar(_image_name, _kata_id, _avatar_name, _starting_files); end
  def old_avatar(_kata_id, _avatar_name); end

  # - - - - - - - - - - - - - - - - -

  def stub_run(stdout, stderr='', status=0)
    dir.make
    dir.write(filename, [stdout,stderr,status])
  end

  def run(_image_name, _kata_id, _name, _deleted_filenames, _changed_files, _max_seconds)
    if dir.exists?
      dir.read(filename)
    else
      ['blah blah blah', '', 0]
    end
  end

  private

  def image_names
    cdf = 'cyberdojofoundation'
    [
      "#{cdf}/nasm_assert",
      "#{cdf}/gcc_assert",
      "#{cdf}/csharp_nunit",
      "#{cdf}/gpp_cpputest"
    ]
  end

  def filename
    'stub_output'
  end

  def dir
    disk[test_id]
  end

  def disk
    @@disk
  end

  def test_id
    ENV['CYBER_DOJO_TEST_ID']
  end

end
