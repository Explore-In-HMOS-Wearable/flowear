import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export async function cancelOlderScheduledNotification() {
  reminderAgentManager.cancelAllReminders().catch((error: BusinessError) => {
    console.info('alarm', `Error creating reminder ${error.code} Msg:${error.message}`);
  });
  console.info('alarm', 'Older notifications cleared');
}

export async function scheduleNotificationForSpecificDate(targetDate: Date) {
  try {
    const nextDate = new Date(targetDate.getTime() + (27 * 24 * 60 * 60 * 1000));
    const reminderRequest: reminderAgentManager.ReminderRequestCalendar = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR,
      dateTime: {
        year: nextDate.getFullYear(),
        month: (nextDate.getMonth() + 1),
        day: nextDate.getDate(),
        hour: 10,
        minute: 20,
        second: 0
      },
      wantAgent: {
        pkgName: 'com.example.watchFiless',
        abilityName: 'EntryAbility'
      }

    };

    reminderRequest.title = 'Your period is Approaching';
    reminderRequest.content = 'How you feeling?';
    reminderRequest.slotType = notificationManager.SlotType.CONTENT_INFORMATION;

    console.info('alarm',
      `date\n year: ${nextDate.getFullYear()}\n month: ${nextDate.getMonth()}\n day: ${nextDate.getDate()}\n hour: ${nextDate.getHours()}\n mins: ${nextDate.getMinutes()}\n ${nextDate.getSeconds()}`);

    const reminderId = await reminderAgentManager.publishReminder(reminderRequest);
    console.info('alarm', `Success! Reminder ID: ${reminderId}`);

  } catch (error) {
    console.error('alarm', `Error creating reminder: ${JSON.stringify(error)}`);
  }
}