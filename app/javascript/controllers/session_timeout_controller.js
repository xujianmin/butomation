import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    timeout: { type: Number, default: 5 }, // 5分钟
    heartbeatInterval: { type: Number, default: 1 } // 1分钟
  }

  connect() {
    this.resetTimer()
    this.setupActivityListeners()
    this.startHeartbeat()
  }

  disconnect() {
    this.clearTimers()
  }

  // 设置用户活动监听器
  setupActivityListeners() {
    const events = ['mousemove', 'mousedown', 'keypress', 'scroll', 'touchstart', 'click']
    events.forEach(event => {
      document.addEventListener(event, () => {
        this.resetTimer()
      }, { passive: true })
    })
  }

  // 用户活动时重置计时器
  resetTimer() {
    this.clearTimers()
    this.startCountdown()
  }

  // 开始倒计时
  startCountdown() {
    const timeoutMs = this.timeoutValue * 60 * 1000 // 转换为毫秒
    this.countdownTimer = setTimeout(() => {
      this.handleSessionExpired()
    }, timeoutMs)
  }

  // 开始心跳
  startHeartbeat() {
    const heartbeatMs = this.heartbeatIntervalValue * 60 * 1000 // 转换为毫秒
    this.heartbeatTimer = setInterval(() => {
      this.sendHeartbeat()
    }, heartbeatMs)
  }

  // 发送心跳更新服务器端会话
  async sendHeartbeat() {
    try {
      const csrfToken = document.querySelector('[name="csrf-token"]')
      if (!csrfToken) {
        return
      }
      
      const response = await fetch('/session/heartbeat', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfToken.content,
          'Content-Type': 'application/json'
        }
      })
      
      if (!response.ok) {
        this.handleSessionExpired()
      }
    } catch (error) {
      // 心跳失败时也触发登出，确保安全性
      this.handleSessionExpired()
    }
  }

  // 清除所有定时器
  clearTimers() {
    if (this.countdownTimer) {
      clearTimeout(this.countdownTimer)
      this.countdownTimer = null
    }
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer)
      this.heartbeatTimer = null
    }
  }

  // 处理会话过期
  handleSessionExpired() {
    this.clearTimers()
    window.location.href = '/session/new?expired=true'
  }
} 