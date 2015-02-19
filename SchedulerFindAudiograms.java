global class SchedulerFindAudiograms implements Schedulable {    
    global void execute(SchedulableContext sc) {        
        TypeformIntegration.findNewAudiogramsOnSchedule(true);
  }
    
    public static void startScheduler() {
        SchedulerFindAudiograms newScheduler = new SchedulerFindAudiograms();
        System.schedule('SchedulerFindAudiograms Job 00', '0 0 * * * ?', newScheduler);
    System.schedule('SchedulerFindAudiograms Job 15', '0 15 * * * ?', newScheduler);
    System.schedule('SchedulerFindAudiograms Job 30', '0 30 * * * ?', newScheduler);
    System.schedule('SchedulerFindAudiograms Job 45', '0 45 * * * ?', newScheduler);  
    }    
}