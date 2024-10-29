require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess].to_s[0] || ''  # Extract the first character or an empty string
    @game.guess(letter) if letter.length > 0  # Call the guess method only if a letter is provided
    redirect '/show'  # Redirect to the show action to display the result
  end
  
  
  get '/show' do
    # Display the game status
    @wrong_guesses = @game.wrong_guesses
    @word_with_guesses = @game.word_with_guesses
    erb :show
  end
  
  
  get '/win' do
    erb :win
  end
  
  get '/lose' do
    erb :lose
  end
  
  
end
