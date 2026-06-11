import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["sampleGrid", "answerGrid"]//Stimulusが自動的に this.sampleGridTarget を使えるようにする
  static values = {
    sample: Array,
    answer: Array,
    score:  { type: Number, default: 0 },
    targetCount: { type: Number, default: 3 },
  }

  GRID_SIZE    = 16
  CORRECT_PASS = 3

  connect() {
    this.isProcessing  = false// 処理中フラグをfalseで初期化
    this.correctStreak = 0// 連続正解数を0で初期化
    this.renderGrids()// グリッドを描画するメソッドを呼ぶ
  }

  renderGrids() {
    this.renderSample()
    this.renderAnswer()
  }
  
  renderSample() {
    const grid = this.sampleGridTarget
    grid.innerHTML = ""
    for (let i = 0; i < this.GRID_SIZE; i++) {
      const cell = document.createElement("div")
      cell.classList.add("w-12", "h-12", "border", "border-base-content/30")
      if (this.sampleValue.includes(i)) {
        cell.classList.add("bg-warning")
      }
      grid.appendChild(cell)
    }
  }

  renderAnswer() {
    const grid = this.answerGridTarget
    grid.innerHTML = ""
    for (let i = 0; i < this.GRID_SIZE; i++) {
      const cell = document.createElement("div")
      cell.dataset.index  = i
      cell.dataset.action = "click->color-grid#selectCell"
      cell.classList.add(
        "w-12", "h-12", "border", "border-base-content/30",
        "cursor-pointer", "transition-colors", "duration-150"
      )
      if (this.answerValue.includes(i)) {
        cell.classList.add("bg-primary")
      }
      grid.appendChild(cell)
    }
  }

   selectCell(event) {
    if (this.isProcessing) return

    const cell     = event.currentTarget
    const index    = parseInt(cell.dataset.index)
    const isOn     = cell.classList.contains("bg-primary")
    const newValue = !isOn

    cell.classList.toggle("bg-primary", newValue)

    if (newValue) {
      this.answerValue = [...this.answerValue, index]
    } else {
      this.answerValue = this.answerValue.filter(i => i !== index)
    }

    const isCorrectDir = this.sampleValue.includes(index) === newValue
    if (!isCorrectDir) {
      this.dispatch("error", { bubbles: true })
      return
    }

    if (this.isComplete()) {
      this.onComplete()
    }
  }

  isComplete() {
    const sample = [...this.sampleValue].sort((a, b) => a - b)
    const answer = [...this.answerValue].sort((a, b) => a - b)
    return JSON.stringify(sample) === JSON.stringify(answer)
  }

  async onComplete() {
    if (this.isProcessing) return
    this.isProcessing = true

    this.correctStreak++
    this.scoreValue++

    const nextTargetCount = this.correctStreak >= this.CORRECT_PASS
      ? Math.min(this.targetCountValue + 1, 5)
      : this.targetCountValue

    if (this.correctStreak >= this.CORRECT_PASS) {
      this.correctStreak = 0
      this.targetCountValue = nextTargetCount
    }

    const token = document.querySelector('meta[name="csrf-token"]').content
    const res   = await fetch("/games/color_grid_complete", {
      method:  "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": token },
      body:    JSON.stringify({
        score:        this.scoreValue,
        target_count: nextTargetCount
      })
    })
    const data = await res.json()

    this.sampleValue = data.next_sample
    this.answerValue = data.next_answer

    this.dispatch("solved", {
      detail:  { score: data.score },
      bubbles: true
    })

    this.renderGrids()
    this.isProcessing = false
  }

  gameEnd() {
    this.isProcessing = true
  }

}
