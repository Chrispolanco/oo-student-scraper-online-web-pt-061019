require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text 
        students << {name: student_name, location: student_location, profile_url: student_link}
      end
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    details = profile_page.css(".social-icon-container").children.css("a").map {|a| a.attribute('href').value}
    details.each do |link|
      link.include?("linkedin")? student[:linkedin] = link: ""
      link.include?("github")? student[:github] = link: ""
      link.include?("twitter")? student[:twitter] = link: ""
      if !link.include?("twitter"||"github"||"linkedin") 
        student[:blog] = link
      end
    end 
      student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
      student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
    student 
  end 
end

