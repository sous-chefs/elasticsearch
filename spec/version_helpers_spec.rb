require_relative '../libraries/versions'

RSpec.describe ElasticsearchCookbook::VersionHelpers do
  subject(:helper) do
    Class.new do
      include ElasticsearchCookbook::VersionHelpers

      def node
        {
          'platform_family' => 'debian',
          'kernel' => { 'machine' => 'x86_64' },
        }
      end
    end.new
  end

  describe '#default_download_url' do
    it 'builds the package URL for 8.19.12' do
      expect(helper.default_download_url('8.19.12')).to eq(
        'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.19.12-amd64.deb'
      )
    end

    it 'builds the package URL for 9.3.1' do
      expect(helper.default_download_url('9.3.1')).to eq(
        'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.3.1-amd64.deb'
      )
    end
  end

  describe '#default_download_checksum' do
    it 'returns SHA-256 checksums for 8.19.12' do
      checksums = helper.default_download_checksum('8.19.12')
      expect(checksums['debian_x86_64']).to eq('0f0e285949ea4c79b072ba56fb135dfe46d73bbf305ec259cc3fd7a7c6758ba5')
      expect(checksums['debian_arm64']).to eq('18c2eee0bdfb9343f1f9c93f19eb85d09500b8e032ec048cf9dc5a96ab8bdddd')
      expect(checksums['rpm_x86_64']).to eq('7c3cdf5304a35ede2f265198fae7aa53640be0bf85d6407eb648413631f6dc2e')
      expect(checksums['rpm_aarch64']).to eq('983f06b47574b8ab3051d8ba491f94d88831ea7457389f47df468d3f9437b017')
    end

    it 'returns SHA-256 checksums for 9.3.1' do
      checksums = helper.default_download_checksum('9.3.1')
      expect(checksums['debian_x86_64']).to eq('de5e7791d9008f1f06e0849529eb38b23c67ac06038924fca2fbb420961f4648')
      expect(checksums['debian_arm64']).to eq('7f0b7babbece684047d1827a58bfe3d5127167265e477efe56eb12efa2c784c2')
      expect(checksums['rpm_x86_64']).to eq('ddce30b32761373d6c0a77e92e2482434d213470c2613612e205798be53d2d8e')
      expect(checksums['rpm_aarch64']).to eq('8ec956f6481a0a59093a3497c49bc5b2a7a020ccf744d6cbe8bb780cf47364a0')
    end

    it 'raises for unsupported versions' do
      expect { helper.default_download_checksum('99.0.0') }.to raise_error(
        RuntimeError, /Unsupported Elasticsearch version: 99.0.0/
      )
    end
  end
end
