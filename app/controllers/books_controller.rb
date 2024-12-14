require "csv"

class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update confirm_destroy destroy ]

  def index
    books = Current.user.books.order("finish_date desc").to_a
    @books_by_year = books.group_by { _1.finish_date.year }

    months = Enumerator.new do |y|
      current_month = Date.current.beginning_of_month
      earliest_month = current_month - 12.months

      m = current_month
      while m >= earliest_month
        y << m
        m -= 1.month
      end
    end.to_a
    @books_per_month_for_last_year = months.map do |month|
      [ month, books.count { _1.finish_date.beginning_of_month == month } ]
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Current.user.books.new(book_params)

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @book.destroy!
    redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed."
  end

  def import_csv_form
  end

  def import_csv
    rows = CSV.parse(params[:csv].read, headers: true)

    ActiveRecord::Base.transaction do
      rows.each do |row|
        book = Current.user.books.new(row.to_h.slice("title", "author", "finish_date", "format", "location"))
        book.save!
      end
    end

    redirect_to books_path, notice: "#{rows.size} books were successfully imported."
  end

  def export_csv
    csv_data = CSV.generate do |csv|
      csv << %w[ title author finish_date format location ]
      Current.user.books.find_each do |book|
        csv << [ book.title, book.author, book.finish_date, book.format, book.location ]
      end
    end

    send_data csv_data, type: "text/csv", filename: "books.csv"
  end

  private
    def set_book
      @book = Current.user.books.find(params.expect(:id))
    end

    def book_params
      params.expect(book: [ :title, :author, :finish_date, :format, :location ])
    end
end
