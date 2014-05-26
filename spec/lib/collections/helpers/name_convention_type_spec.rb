require './lib/collections/helpers/name_convention_type'
RSpec.describe Collections::NameConventionType do

  list_of_pural_words = [
      'berries',
      'activities',
      'foxes',
      'stomachs',
      'epochs',
      'knives',
      'halves',
      'scarves',
      'chiefs',
      'spoofs',
      'solos',
      'avocados',
      'embryos',
      'studios',
      'embargoes',
      'tuxedos',
    ]

  describe "given we pass in a plural word" do
        
    list_of_pural_words.each do |word|
      
      let(:object) { Collections::NameConventionType.new(word) }
      
      it "will return true if #{word} was plural" do
        expect(object.plural?).to be_true
      end
    end
  end

  list_of_non_pural_words = [
    'berry',
    'activity',
    'daisy',
    'church',
    'fox',
    'epoch',
    'knife',
    'scarf',
    'chief',
    'zero',
    'embryo',
    'embargo',
    'mosquito',
  ]

  describe "given we pass in a non-plural word" do
    
    list_of_non_pural_words.each do |word|
      
      let(:object) { Collections::NameConventionType.new(word) }
      
      it "will return false if #{word} was not plural" do
        expect(object.plural?).to be_false
      end
    end
  end
end
