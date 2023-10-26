# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy update edit mark]

  def new
    @answer = @question.answers.build
    3.times { @answer.links.build }
  end

  def edit; end

  def create
    @answer = @question.answers.build(answer_params)

    respond_to do |format|
      format.html do
        if @answer.save
          redirect_to @question, notice: 'Your answer successfully created.'
        else
          @new_answer = @answer
          render 'questions/show'
        end
      end
      format.turbo_stream do
        if @answer.save
          @new_answer = @question.answers.new
          @new_answer.links.new
          flash.now[:notice] = 'Your answer successfully created.'
        else
          @new_answer = @answer
          @new_answer.links.new
        end
        render
      end
    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    return unless current_user.user_of? @answer

    @question = @answer.question
    @answer.destroy
    respond_to do |format|
      format.html do
        redirect_to @question, notice: 'Answer was successfully deleted'
      end
      format.turbo_stream do
        flash.now[:notice] = 'Answer was successfully deleted'
        render
      end
    end
  end

  def mark
    @question = @answer.question
    old_answer = @question.answers.find_by(mark: true)
    if @answer == old_answer
      @answer.update(mark: false)
    else
      old_answer&.update(mark: false)
      @answer.update(mark: true)
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: %i[id name url _destroy]).merge(user: current_user)
  end
end
