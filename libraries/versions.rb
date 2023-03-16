module ElasticsearchCookbook
  module VersionHelpers
    def default_download_url(version)
      platform_family = node['platform_family']
      machine = node['kernel']['machine']

      case platform_family
      when 'debian'
        arch = machine.include?('x86_64') ? 'amd64' : 'arm64'
        file_type = 'deb'
      when 'rhel'
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
      when '6.5.0'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.5.1'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.5.2'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => '9cb0997dc6d2be16c988c0ee43ccafd19a8b2e757326af84f4cead40f74c614f',
        }
      when '6.5.3'
        {
          'rpm_x86_64' => '2f3eb7682e06211061bea90a0314a515f0c4ef683f45c8e57bfb1dfb14679c3a',
          'debian_x86_64' => '38b30461201fe8d126d124f04d961e7c037bea7a6fb9ca485c08e681d8d30456',
        }
      when '6.5.4'
        {
          'rpm_x86_64' => 'aa4006f754bd1a0bfaa338ba40d93a1762917c1862951577c62b1f073026b5ba',
          'debian_x86_64' => 'c0a062ffb45f989cd3091c66f62605178c41c3735991d95506a6986a90924833',
        }
      when '6.6.0'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.6.1'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.6.2'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.7.0'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.7.1'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.7.2'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.8.2'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.8.3'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.8.4'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.8.5'
        {
          'rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '6.8.6'
        {
          'rpm_x86_64' => '4880396d1a78046efe4a6ec45c1cc2f1f9f0d328466aa32355e95f9834d9d0af',
          'debian_x86_64' => '82dce29bb3c9108f44e936c3fc6200ce7264bb1a27c1a1cc6dde39b6eac03487',
        }
      when '7.0.1'
        {
          'x86_64rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_arm64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '7.1.0'
        {
          'debian_arm64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'x86_64rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        }
      when '7.1.1'
        {
          'x86_64rpm_x86_64' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'debian_arm64' => '2ef15cb7e37d32b93c51ad537959831bd72cac2627f255d22cc574cec5de6aef',
        }
      when '7.2.0'
        {
          'debian_x86_64' => '1ff7b88c4bc38438a67719df499b17d4f7082a77eda89f39016f83414554ea95',
          'rpm_x86_64' => 'a854decb443631a0031a9492c1d5acbed00222381cb63cba68ae6d5deee3994c',
        }
      when '7.2.1'
        {
          'debian_x86_64' => '41f507b83fc49a3da5109afd18cc626ec5458acf567f00a80ac3f1c34b6d4b7f',
          'rpm_x86_64' => '96fdac0a8e6c74182d920b39e3f4830b722731a646126222c189e12a95302e6e',
        }
      when '7.3.0'
        {
          'debian_x86_64' => '72ae24cf0f5d97a307f35d116a41e1165e80f58f08b0ca4e6de3ec5228f06f9c',
          'rpm_x86_64' => 'f49dc809cf48369b70546f13dfb28b43e1a07387b681ca786c794762d52847ca',
        }
      when '7.3.1'
        {
          'debian_x86_64' => '570af7456603fd103408ed61ccec4473302976d46e1ff845b74a881122977e02',
          'rpm_x86_64' => '240f93d16da4c20d2cc377b7c6a61dbf4fb9634d74829ccb5f7cd42c023bc967',
        }
      when '7.3.2'
        {
          'debian_x86_64' => '690e98653b3dc50ec5f8e65c480ec41c8c4db0d2c63b5ed3f25fef53d6aaaa55',
          'rpm_x86_64' => 'bdada0a4c7b5574c41726154212b6b25373e2b4d7d2a64e24238b206ad422ecd',
        }
      when '7.4.0'
        {
          'debian_x86_64' => '3edf17d9d63a08a0f7eb7d9727a1737e1c770277f64fe44342115e62f752cc51',
          'rpm_x86_64' => '1bfae41734c77af3bc66084ac0cc04add1190f9311b045d3c184ea7b3e688334',
        }
      when '7.4.1'
        {
          'debian_x86_64' => '55a92288e81856e9bb6c36c0f7149b24cf36432527ca809fc48e25775b0cf584',
          'rpm_x86_64' => '8ec30fbd95235cb15d0f27cd40f75a43f640f5832e2ee2d44fe8d2983cd5724f',
        }
      when '7.4.2'
        {
          'debian_x86_64' => '514a8e21e173481edb9130ebbf33f15209b467df5c2222632d63c4527c16abc6',
          'rpm_x86_64' => 'af616eed2cd30411f400dee0c993eb8fccd55e510548697d7cc0eb178ac4adec',
        }
      when '7.5.0'
        {
          'debian_x86_64' => '5b167d15461049f6aa58a96d805c9bcd297ad19467392eea125ce91c5eaaf908',
          'rpm_x86_64' => 'a8e802c74c3163272fb7119a9d23c1e8f7bbe76e6502a3fcc30709705bc57f4a',
        }
      when '7.5.1'
        {
          'debian_x86_64' => 'e566a88e15d8f85cf793c8f971b51eeae6465a0aa73f968ae4b1ee6aa71e4c20',
          'rpm_x86_64' => 'e6202bba2bd8644d23dcbef9ad7780c847dfe4ee699d3dc1804f6f62eed59c2d',
        }
      when '7.16.3'
        {
          'debian_x86_64' => '03992d97930b734155981076b3cd250c22742f3876f5f135f374940d1cb3ae2e',
          'debian_arm64' => 'c383e5b45eb070e1b6d53b9dc56218634794e2e0b27ea42a7d4a12650eec2b70',
          'rpm_aarch64'  => 'f833e86db87240bcdc822ea40fc6103f019c35bafcfd7ac6063ef01d5b588e1c',
          'rpm_x86_64' => '9edf142b9a25b9000a9bf8638bc0590916f367b66e4abb3ce80d8f00f9de0c9c',
        }
      when '7.17.8'
        {
          'debian_x86_64' => 'd4875477129214519f6150aaf35374103f075886913307d6ed7c138d04ae6fa1',
          'debian_arm64' => '7dd69704b8d6d71aa58bb05f86d63fb34c00f2fcabdff244e9dab37226ca48af',
          'rpm_aarch64'  => 'bb151d40c7979e5c5c6b9b1a227d494bb463642af938a6b21ae46a4eae767c74',
          'rpm_x86_64' => 'd1d1cf15143029c658224d39ebf174f8da802bb26800cd88f974ad2a0ee16484',
        }
      when '7.17.9'
        {
          'debian_x86_64' => '7832e13c0b67239370058b729d321af1a12f0b329c0a3828c57d2fd4a9cb6555',
          'debian_arm64' => 'ec7064982bd3601280478b5d1ea01b8b8d95cbaaffad441e7bef194c53e8cccd',
          'rpm_aarch64'  => '16a6e97440b0a4542d9d69168287fe143d40db138e9a3fd3e6348e60abe77175',
          'rpm_x86_64' => '751beebbe28ebefcd451796c1075208421b109bdae752383122142fd00a04559',
        }
      when '8.6.1'
        {
          'debian_x86_64' => 'a4ea8a7409a9c32752688f03f1df628624fa48a1c38bc5d0eee21883d5b34083',
          'debian_arm64' => '84fbd0d36e98aff028eac5027e4bcc2cc8b84bf63dc175fc72e4ea3649c5c8b7',
          'rpm_aarch64' => '39e80fe8cc3b864601848e008cf8a0b45b76076408abac093bedc14d0c1328bf',
          'rpm_x86_64' => '939daa9480693df658d75bd38c75c2cbf5876e31ff74a543ef8a9d45a81ac728',
        }
      when '8.6.2'
        {
          'debian_x86_64' => '8bd0b859e7fa7df8d9e632120c327530f088c5b564cd3b5538eda1b92a181676',
          'debian_arm64' => '6e0088c9ac8c2d51f3d60360607f344b6511feaf5d0f3931a4c9d81448757ba9',
          'rpm_aarch64' => 'f20a70195e807e1b2981ec37960df8fffef5412f89936b0834d9e8d64d2c8cc1',
          'rpm_x86_64' => '5fc28cdfd3aeeeb746778ca873ce47d9836eb6d26746a562b98650c655bb8a3b',
        }
      else
        raise "Unsupported version #{version}"
      end
    end
  end
end
