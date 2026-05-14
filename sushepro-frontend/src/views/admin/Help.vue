<template>
  <div class="help">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title flex items-center gap-sm">
          <span class="material-icons">help</span> 帮助中心
        </h2>
        <p class="page-subtitle">获取系统使用帮助和常见问题解答。</p>
      </div>
    </div>

    <!-- Help Sections -->
    <div class="help-content">
      <div class="help-section">
        <h3 class="section-title">
          <span class="material-icons">quiz</span> 常见问题
        </h3>
        <div class="faq-list">
          <div class="faq-item">
            <h4 class="faq-question">如何进行宿舍分配？</h4>
            <p class="faq-answer">在管理员面板的"分配管理"页面，您可以查看待分配学生并为她们分配宿舍。</p>
          </div>
          <div class="faq-item">
            <h4 class="faq-question">如何处理调换申请？</h4>
            <p class="faq-answer">在"调换管理"页面，点击查看按钮可以审核学生的调换申请，通过或拒绝申请。</p>
          </div>
          <div class="faq-item">
            <h4 class="faq-question">如何标记报修处理状态？</h4>
            <p class="faq-answer">在"报修管理"页面，您可以标记报修为处理中、已完成或已拒绝状态。</p>
          </div>
          <div class="faq-item">
            <h4 class="faq-question">如何使用AI推荐功能？</h4>
            <p class="faq-answer">在"AI匹配"页面，选择学生并输入特殊要求，系统将为您推荐最合适的宿舍。</p>
          </div>
        </div>
      </div>

      <div class="help-section">
        <h3 class="section-title">
          <span class="material-icons">contact_support</span> 联系我们
        </h3>
        <div class="contact-info">
          <p>如需更多帮助，请联系系统管理员。</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-high: #e7e8e9;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$primary: #0058bc;
$primary-fixed: #d8e2ff;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.help {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.page-header {
  margin-bottom: 24px;

  .page-title {
    font-size: 32px;
    font-weight: 400;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;

    .material-icons {
      color: $primary;
    }
  }

  .page-subtitle {
    font-size: 18px;
    color: $on-surface-variant;
    margin-top: 8px;
  }
}

.help-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.help-section {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 24px;

  .section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 600;
    color: $on-surface;
    margin-bottom: 16px;

    .material-icons {
      color: $primary;
      font-size: 24px;
    }
  }
}

.faq-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.faq-item {
  padding: 16px;
  background: $surface-low;
  border-radius: 8px;

  .faq-question {
    font-size: 16px;
    font-weight: 600;
    color: $on-surface;
    margin-bottom: 8px;
  }

  .faq-answer {
    font-size: 14px;
    color: $on-surface-variant;
    line-height: 1.5;
  }
}

.contact-info {
  font-size: 14px;
  color: $on-surface-variant;
}
</style>