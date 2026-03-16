# frozen_string_literal: true

module ElasticsearchCookbook
  module VersionHelpers
    def default_download_url(version)
      platform_family = node['platform_family']
      machine = node['kernel']['machine']

      case platform_family
      when 'debian'
        arch = machine.include?('x86_64') ? 'amd64' : 'arm64'
        file_type = 'deb'
      when 'rhel', 'fedora', 'amazon'
        arch = machine.include?('x86_64') ? 'x86_64' : 'aarch64'
        file_type = 'rpm'
      else
        raise "Unsupported platform family: #{platform_family}"
      end

      base_url = 'https://artifacts.elastic.co/downloads/elasticsearch'
      "#{base_url}/elasticsearch-#{version}-#{arch}.#{file_type}"
    end

    def checksum_platform
      platform_family = node['platform_family']
      arch = if arm?
               platform_family == 'debian' ? 'arm64' : 'aarch64'
             else
               'x86_64'
             end

      "#{platform_family == 'debian' ? 'debian' : 'rpm'}_#{arch}"
    end

    def default_download_checksum(version)
      case version
      when '8.17.10'
        {
          'debian_x86_64' => 'eda2f5f9049dee74f96cfec05a6e0a065c1624eef2b26179f4e90b1184c29a9b',
          'debian_arm64' => '125d269cde8e17a1835e071e19e39b8cd65fed7b963d923849dde78de8a6bb9b',
          'rpm_aarch64' => 'a312a517f0dde7bbc41de3036e9f5a61c15a5111712ee6c8e014968ac9650a75',
          'rpm_x86_64' => '74c07b06a55d29a529a83d2f408b5a268ad006bdd16d38a320a1ae2d3be5e587',
        }
      when '8.19.12'
        {
          'debian_x86_64' => '0f0e285949ea4c79b072ba56fb135dfe46d73bbf305ec259cc3fd7a7c6758ba5',
          'debian_arm64' => '18c2eee0bdfb9343f1f9c93f19eb85d09500b8e032ec048cf9dc5a96ab8bdddd',
          'rpm_aarch64' => '983f06b47574b8ab3051d8ba491f94d88831ea7457389f47df468d3f9437b017',
          'rpm_x86_64' => '7c3cdf5304a35ede2f265198fae7aa53640be0bf85d6407eb648413631f6dc2e',
        }
      when '9.0.8'
        {
          'debian_x86_64' => '70cfa5c8697c54f4a94c03171fc65ecce3c9a468083be2a1972f3e87b360cada',
          'debian_arm64' => '6c610619b933325d1e1c08832616be5051ae3da4fa5710e128004ffb76ca31a9',
          'rpm_aarch64' => 'da8a24318a00a5217dc38311a9641d1724f45e6baba631074a6bb048ed53b5c5',
          'rpm_x86_64' => '4a66577f18a2bbc755145b8c4ba1fb04ad449004cd294b46be9ba897a3af1299',
        }
      when '9.1.10'
        {
          'debian_x86_64' => '5d8703a3db8a66acb3fbf8dd5001ecbbc7bef31cf4ad4997ed58201504106f04',
          'debian_arm64' => 'a66be17eb8ccb335220a08b55a3bbe6821e44e9f1eae69363e41f04161525dfb',
          'rpm_aarch64' => '2ee2f3723b5ad9b3093135b89be2a564a704b9377a61abb1f845ea643784b36f',
          'rpm_x86_64' => 'b948bcbde30f039b1ee8e92b259e6bee270d10b099fb28fc52325cd7639c0ea3',
        }
      when '9.2.6'
        {
          'debian_x86_64' => '817a58c23427acbd50386811143f49222ef8d0e4965bb56a5ebb7cb4da0916b4',
          'debian_arm64' => 'd5f48925b62e00341a167cf7b96805cd7ab4285087a057ccf1e7c8224b865b2b',
          'rpm_aarch64' => '85e49c7f0deb66deb36c84e4ac015fcbbce7059c0f263baee09e7f66d979e4fc',
          'rpm_x86_64' => 'b9587443287f5151724f0762075a72f4b9b2970ffe5e7a506df5315903bfecf9',
        }
      when '9.3.1'
        {
          'debian_x86_64' => 'de5e7791d9008f1f06e0849529eb38b23c67ac06038924fca2fbb420961f4648',
          'debian_arm64' => '7f0b7babbece684047d1827a58bfe3d5127167265e477efe56eb12efa2c784c2',
          'rpm_aarch64' => '8ec956f6481a0a59093a3497c49bc5b2a7a020ccf744d6cbe8bb780cf47364a0',
          'rpm_x86_64' => 'ddce30b32761373d6c0a77e92e2482434d213470c2613612e205798be53d2d8e',
        }
      else
        raise "Unsupported Elasticsearch version: #{version}. Supported versions: 8.17.10, 8.19.12, 9.0.8, 9.1.10, 9.2.6, 9.3.1"
      end
    end
  end
end
