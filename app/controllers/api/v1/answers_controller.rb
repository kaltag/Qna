# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: %i[show update destroy]

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer, serializer: AnswerWithAdditionsSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    authorize @answer

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }
    end
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }
    end
  end

  def destroy
    authorize @answer

    @answer.destroy
    render json: 'Answer was successfully deleted'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: %i[id name url _destroy]).merge(user: current_user)
  end
end
