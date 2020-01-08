class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  require 'rly'

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # memos operations

  def insert_one(ones, new_one)
    if new_one.number < 1 then
      new_one.record_timestamps = false
      new_one.update_attributes({number: 1})
    elsif new_one.number > ones.count then
      new_one.record_timestamps = false
      new_one.update_attributes({number: ones.count })
    end

    new_number = 1
    for one in ones do
      if one != new_one
        if new_number == new_one.number
          new_number += 1
        end
        if new_number != one.number
          one.record_timestamps = false
          one.update_attributes({number: new_number})
        end
        new_number += 1
      end
    end
  end

  def delete_one(ones)
    new_number = 1
    for one in ones do
      if new_number != one.number
        one.record_timestamps = false
        one.update_attributes({number: new_number})
      end
      new_number += 1
    end
  end

  # tags operations

  class SearchParse < Rly::Yacc
  
    precedence :left,  '|'
    precedence :left,  '&'
    precedence :right, '!'
  
    rule 'statement : expression' do |st, e|
      st.value = e.value
    end
  
    rule 'expression : expression "|" expression' do |ex, e1, op, e2|
      ex.value = "#{e1.value} UNION #{e2.value}"
    end
  
    rule 'expression : expression "&" expression' do |ex, e1, op, e2|
      ex.value = "#{e1.value} INTERSECT #{e2.value}"
    end

    rule 'expression : "!" expression' do |ex, op, e|
      ex.value = "SELECT note_id FROM tagships EXCEPT #{e.value}"
    end
  
    rule 'expression : "(" expression ")"' do |ex, _, e, _|
      ex.value = "(#{e.value})"
    end
  
    rule 'expression : NAME' do |ex, n|
      tag = Tag.find_by(name: n.value)
      if tag
        ex.value = "SELECT note_id FROM tagships WHERE tag_id=#{tag.id}"
      else
        raise "Invalid tag name"
      end
    end
  
    lexer do
      literals '!|&()'
      ignore " \t\n"
  
      token :NAME, /[^!|&() ]+/
  
      on_error do |t|
        raise "Illegal character"
        t.lexer.pos += 1
        nil
      end
    end
  end

  def make_tag_list(tags)
    tag_names = []
    tags.each do |tag|
      tag_names.append(tag.name)
    end
    tag_names.join(", ")
  end

  def search_notes_with_sql(notes, search_sql)
    if search_sql
      notes.where("id IN (#{search_sql})")
    else
      notes
    end
  end

  def get_tags_from_notes(notes)
    if notes
      tag_ids = "SELECT tag_id FROM tagships WHERE note_id IN (:note_ids)"
      Tag.where("id IN (#{tag_ids})", note_ids: notes.ids)
    else
      nil
    end
  end

end
