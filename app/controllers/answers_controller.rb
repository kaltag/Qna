# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  helper_method :question

  def create
    @answer = question.answers.new(answer_params)
    redirect_to question_path(question), notice: 'Your answer successfully created.' if @answer.save
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
