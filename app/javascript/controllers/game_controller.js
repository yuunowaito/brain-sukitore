import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timer", "score", "errorBanner"]
  static values = { answer: String, score: Number }

  connect() {
    this.timeLeft = 30
    this.scoreValue = 0
    this.startTimer()
  }

  disconnect() {
  clearInterval(this.interval)  // ページを離れたときにタイマーを止める
  }

  startTimer() {
    this.timerTarget.textContent = this.timeLeft
    this.interval = setInterval(() => {
      this.timeLeft -= 1
      this.timerTarget.textContent = this.timeLeft
      if (this.timeLeft <= 0) {
        clearInterval(this.interval)
        this.finish()
      }
    }, 1000)
  }
  async selectAnswer(event) {
    const selected = event.currentTarget.dataset.choice
    const response = await fetch("/games/answer", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        selected: selected,
        answer: this.answerValue
      })
    })
    const data = await response.json()
    if (data.correct) {
      this.scoreValue = data.score
      this.scoreTarget.textContent = data.score
      this.answerValue = data.question.answer
      this.dispatch("questionUpdated", { 
        detail: { question: data.question },
        bubbles: true,
        cancelable: false
      })
    }
  }
  finish() {
    const isColorGrid = this.element.dataset.controller.includes("color-grid")
    if (isColorGrid) {
      window.location.href = `/games/result?score=${this.scoreValue}&game_type=color_grid`
    } else {
      window.location.href = `/games/result?score=${this.scoreValue}`
    }
  }

  gameError(event) {
    this.flashBanner()
  }

  flashBanner() {
    this.errorBannerTarget.classList.remove("opacity-0")
    this.errorBannerTarget.classList.add("opacity-100")
    setTimeout(() => {
      this.errorBannerTarget.classList.remove("opacity-100")
      this.errorBannerTarget.classList.add("opacity-0")
    }, 300)
  }

  colorGridSolved(event) {
    this.scoreValue = event.detail.score
    this.scoreTarget.textContent = event.detail.score
  }
}