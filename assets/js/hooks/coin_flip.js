export const CoinFlip = {
  mounted() {
    // Internal rotation state so we keep accumulating spins
    this.rotation = 0
    this.reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches

    this.handleEvent("animate_coin", ({ spins, face, duration }) => {
      if (this.reduce) {
        // Respect reduced motion: complete immediately
        this.pushEvent("flip_done", {})
        return
      }

      const coin = this.el.querySelector("[data-coin]")
      if (!coin) return

      this.rotation = spins * 360 + face

      coin.style.transitionProperty = "transform"
      coin.style.transitionTimingFunction = "cubic-bezier(0.19, 1, 0.22, 1)"
      coin.style.transitionDuration = `${duration}ms`
      coin.style.transform = `rotateY(${this.rotation}deg)`

      const onEnd = () => {
        coin.removeEventListener("transitionend", onEnd)

        this.pushEvent("flip_done", {})
      }
      coin.addEventListener("transitionend", onEnd)
    })

    this.handleEvent("reset_coin", () => {
      const coin = this.el.querySelector("[data-coin]")
      if (!coin) return
      this.rotation = 0
      coin.style.transitionDuration = "0ms"
      coin.style.transform = "rotateY(0deg)"
      // Force reflow so subsequent transitions apply cleanly
      // eslint-disable-next-line no-unused-expressions
      coin.offsetHeight
      coin.style.transitionDuration = ""
    })
  }
}
