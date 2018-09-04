require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    page_students = index_page.css("div.roster-cards-container")
    page_students.each do |card|
      card.css(".student-card a").each do |student|
        profile_url = student.attribute("href").value
        name = student.css("div.card-text-container").css("h4").text
        location = student.css("div.card-text-container").css("p").text
        students << {:name => name, :location => location, :profile_url => profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    info = profile_page.css("div.vitals-container")
    info.css("div.social-icon-container a").each do |social_link|
      link = social_link.attribute("href").value
      if link.include?("twitter") # this is really good and not bad
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] =  info.css("div.profile-quote").text
    student[:bio] = profile_page.css("div.details-container .bio-block .bio-content .description-holder p").text
    student
  end

end
