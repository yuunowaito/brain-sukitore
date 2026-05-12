import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-janken"
export default class extends Controller {
  static targets = ["question"]
  static values = { answer: String }

  gameQuestionUpdated(event) {
    const question = event.detail.question
    const color = question.color
    const hand = question.hand

    this.questionTarget.src = `/assets/${hand}_${color}.svg`
    this.questionTarget.previousElementSibling.textContent =
      color === "blue" ? "勝つ手を出せ！" : "負ける手を出せ！"
    this.answerValue = question.answer
  }
}