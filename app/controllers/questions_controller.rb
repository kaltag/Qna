# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.left_joins(:votes).group(:id).order('sum(votes.voice)')
  end

  def show
    if params[:layout] == 'simple'
      render 'questions/_show_simple', locals: { question: @question }
    else
      @new_answer = @question.answers.new
      @new_answer.links.new
    end
  end

  def new
    @question = Question.new
    @question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    return unless current_user.user_of? @question

    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy],
                                                    reward_attributes: %i[id name file _destroy])
  end

  def remove_files
    remove_files = question_params[:remove_files]
    ActiveStorage::Attachment.find(remove_files).each(&:purge)
  end
end
