# frozen_string_literal: true

class AnswersController < ApplicationController
  helper_method :question

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(question, @answer)
    else
      render :new
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
