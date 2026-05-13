import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-janken"
export default class extends Controller {
  static targets = ["question"]
  static values = { answer: String, images: Object  }

  gameQuestionUpdated(event) {
    const question = event.detail.question
    const key = `${question.hand}_${question.color}`
    this.questionTarget.src = this.imagesValue[key]
    this.questionTarget.previousElementSibling.textContent =
      question.color === "blue" ? "勝つ手を出せ！" : "負ける手を出せ！"
    this.answerValue = question.answer
  }
}