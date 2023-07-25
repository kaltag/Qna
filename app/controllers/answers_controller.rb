# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update edit mark]

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    redirect_to question_path(@question), notice: 'Your answer successfully created.' if @answer.save
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
    else
      redirect_to answer, notice: 'You can only delete your own answer.'
    end
  end

  def mark
    @question = @answer.question
    old_answer = @question.answers.find_by(mark: true)
    if @answer != old_answer
      old_answer&.update(mark: false)
      @answer.update(mark: true)
      redirect_to @question
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
