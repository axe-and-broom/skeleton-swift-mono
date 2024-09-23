# Scope related tasks under a namespace
namespace 'tools' do
  desc 'xcodegen (https://github.com/yonaskolb/XcodeGen)'
  task :xcodegen, [:shell_params] do |t, args|
    standard_args = ""
    tool_args = "#{standard_args} #{args[:shell_params]} #{ARGV.drop(1).join(' ')}"
    sh "rake tools:mint\\[\"run xcodegen #{tool_args}\"\\]"
  end

  desc 'mint (https://github.com/yonaskolb/Mint)'
  task :mint, [:shell_params] do |t, args|
    standard_args = ""
    tool_args = "#{standard_args} #{args[:shell_params]} #{ARGV.drop(1).join(' ')}"
    sh "(cd utils/spm-bin-tools/mint_ && MINT_PATH=\"../../../utils/vendor/mint\" MINT_LINK_PATH=\"../../../utils/vendor/mint/bin\" swift run -c release mint #{tool_args})"
  end
end
