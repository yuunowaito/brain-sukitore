import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hiragana-calc"
export default class extends Controller {
  static targets = ["question", "choices"]
  static values = { answer: Number }

  gameQuestionUpdated(event) {
    const question = event.detail.question
    this.questionTarget.textContent = question.text + " ＝ ？"
    this.answerValue = question.answer
    this.choicesTarget.innerHTML = question.choices.map(choice => `
      <button class="btn btn-outline btn-lg text-3xl font-bold h-28"
              data-action="click->game#selectAnswer"
              data-choice="${choice}">
        ${choice}
      </button>
    `).join("")
  }
}