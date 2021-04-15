module Ffxiv
  module Lodestone
    class Character < Model

      attr_accessor :id, :name, :server, :data_center, :thumbnail_uri, :image_uri,
                    :race, :subrace, :gender, :nameday, :birthday, :guardian,
                    :city_state, :grand_company, :grand_company_rank, :free_company,
                    :self_introduction, :classes

      class << self

        def search(keyword, server: nil, page: 1, verbose: false)
          dom = Lodestone.fetch('character', q: keyword, worldname: server, page: page)

          dom.css(".entry__link").map do |a|
            id = a.attr('href').split('/').last.to_i

            next self.find_by_id(id) if verbose

            name = a.css('.entry__name').text
            thumbnail = a.css('.entry__chara__face img').attr('src')
            server, datacenter = a.css('.entry__world').text.gsub(/[()]/, '').split("\u00A0")

            self.new({
              id: id,
              name: name,
              server: server,
              data_center: datacenter,
              thumbnail_uri: drop_query(thumbnail)
            })
          end
        end

        def name_to_id(name, server)
          search_result = self.search(name, server: server)

          return nil unless search_result

          search_result[:characters].each do |ch|
            return ch.id if name.downcase == ch.name.downcase
          end
        end

        @@disciplines = {
          "Paladin / Gladiator"      => 'Disciple of War',
          "Warrior / Marauder"       => 'Disciple of War',
          "Dark Knight"              => 'Disciple of War',
          "Gunbreaker"               => 'Disciple of War',
          "White Mage / Conjurer"    => 'Disciple of Magic',
          "Scholar"                  => 'Disciple of Magic',
          "Astrologian"              => 'Disciple of Magic',
          "Monk / Pugilist"          => 'Disciple of War',
          "Dragoon / Lancer"         => 'Disciple of War',
          "Ninja / Rogue"            => 'Disciple of War',
          "Samurai"                  => 'Disciple of War',
          "Bard / Archer"            => 'Disciple of War',
          "Machinist"                => 'Disciple of War',
          "Dancer"                   => 'Disciple of War',
          "Black Mage / Thaumaturge" => 'Disciple of Magic',
          "Summoner / Arcanist"      => 'Disciple of Magic',
          "Red Mage"                 => 'Disciple of Magic',
          "Blue Mage"                => 'Disciple of Magic',
          "Carpenter"                => 'Disciple of the Hand',
          "Blacksmith"               => 'Disciple of the Hand',
          "Armorer"                  => 'Disciple of the Hand',
          "Goldsmith"                => 'Disciple of the Hand',
          "Leatherworker"            => 'Disciple of the Hand',
          "Weaver"                   => 'Disciple of the Hand',
          "Alchemist"                => 'Disciple of the Hand',
          "Culinarian"               => 'Disciple of the Hand',
          "Miner"                    => 'Disciple of the Land',
          "Botanist"                 => 'Disciple of the Land',
          "Fisher"                   => 'Disciple of the Land',
        }.freeze

        def find_by_id(id)
          dom = Lodestone.fetch("character/#{id}")

          props = {}

          props[:id] = id

          props[:name] = dom.css('.frame__chara__name').text
          props[:server], props[:data_center] = dom.css('.frame__chara__world').text.gsub(/[()]/, '').split("\u00A0")
          props[:thumbnail_uri] = drop_query(dom.css(".frame__chara__face img").attr("src"))
          props[:image_uri] = drop_query(dom.css(".js__image_popup").attr("href"))

          # race_block needs special handling
          race_block, *other_blocks = dom.css('.character-block__name')

          props[:race] = race_block.children.first.text
          props[:subrace], gender = race_block.children.last.text.split(' / ')

          props[:gender] = case gender
                           when "♀" then :female
                           when "♂" then :male
                           else raise "Unrecognized gender symbol: #{gender}"
                           end

          props[:guardian], props[:'city-state'], grand_company_info = other_blocks.map { _1.text }
          props[:grand_company], props[:grand_company_rank] = grand_company_info.split(' / ')

          props[:nameday] = dom.css('.character-block__birth').text
          props[:birthday] = Utils.ed2gd(props[:nameday])

          props[:self_introduction] = dom.css(".character__selfintroduction").text

          class_hash = {
            'Disciple of War' => {},
            'Disciple of Magic' => {},
            'Disciple of the Hand' => {},
            'Disciple of the Land' => {},
          }

          props[:classes] = dom.css('.character__level__list li').each_with_object(class_hash) do |li, classes|
            class_name = li.css('img').attr('data-tooltip').value
            # Blue Mage has some extra junk in it
            class_name = 'Blue Mage' if class_name.include? 'Blue Mage'
            level = li.text.to_i

            discipline = @@disciplines[class_name]

            classes[discipline][class_name] = level
          end

          self.new(props)
        end
      end

      def thumbnail_uri
        @thumbnail_uri + "?#{Time.now.to_i}"
      end

      def image_uri
        @image_uri + "?#{Time.now.to_i}"
      end

    end
  end
end
