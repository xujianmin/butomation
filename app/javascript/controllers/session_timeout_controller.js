import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    timeout: { type: Number, default: 15 }, // 15分钟
    heartbeatInterval: { type: Number, default: 15 } // 15分钟
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
    
    // 添加防抖机制，避免频繁重置
    let resetTimeout
    const debouncedReset = () => {
      clearTimeout(resetTimeout)
      resetTimeout = setTimeout(() => {
        this.resetTimer()
      }, 1000) // 1秒防抖
    }
    
    events.forEach(event => {
      document.addEventListener(event, debouncedReset, { passive: true })
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
      
      if (response.status === 401) {
        this.clearTimers()
        this.handleSessionExpired()
        return
      } else if (!response.ok) {
        this.clearTimers()
        this.handleSessionExpired()
        return
      }
    } catch (error) {
      this.clearTimers()
      this.handleSessionExpired()
      return
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
  async handleSessionExpired() {
    this.clearTimers()
    
    try {
      // 先发送登出请求到服务器
      const csrfToken = document.querySelector('[name="csrf-token"]')
      if (csrfToken) {
        await fetch('/session', {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': csrfToken.content,
            'Content-Type': 'application/json'
          }
        })
      }
    } catch (error) {
      console.log('登出请求失败:', error)
    }
    
    // 清理所有可能的会话状态
    this.clearSessionData()
    
    // 跳转到登录页面，并添加expired参数
    window.location.href = '/session/new?expired=true'
  }

  // 清理会话数据
  clearSessionData() {
    // 清理localStorage和sessionStorage中的相关数据
    localStorage.removeItem('session_data')
    sessionStorage.clear()
    
    // 清理可能的cookies（除了httponly的）
    document.cookie.split(";").forEach(function(c) { 
      document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
    });
  }
} 