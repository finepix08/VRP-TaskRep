public class CourseAssignment {
    
    public static Map<String, List<recommendedCourse>> getSuggestedCourses (List<Student__c> students) {

        Map <String, List<Id>> StudentAllSkill = new Map <String, List<Id>>();
        for (Preferences__c student: [Select Preferences__c.Student__r.Name, Skill__c FROM Preferences__c]) {
            if (StudentAllSkill.containsKey(student.Student__r.Name)) {
                List<Id> skillsId = StudentAllSkill.get(student.Student__r.Name);
                skillsId.add(student.Skill__c);
                StudentAllSkill.put((student.Student__r.Name), skillsId);
            } else {
                StudentAllSkill.put((student.Student__r.Name),new List<Id>{student.Skill__c});
            }
        }

        Map <String, List<Id>> CourseAllSkill = new Map <String, List<Id>>();
        for (Discipline__c course: [Select Discipline__c.Course__r.Name, Skill__c FROM Discipline__c]) {
            if (CourseAllSkill.containsKey(course.Course__r.Name)) {
                List<Id> skillsId = CourseAllSkill.get(course.Course__r.Name);
                skillsId.add(course.Skill__c);
                CourseAllSkill.put((course.Course__r.Name), skillsId);
            } else {
                CourseAllSkill.put((course.Course__r.Name),new List<Id>{course.Skill__c});
            }
        }


        Map <String, Course__c> AllCoursesMap = new Map <String, Course__c>();
        List<Course__c> AllCourses = new List<Course__c>([SELECT Name FROM Course__c]);
        for(Course__c courseObj: AllCourses) {
            AllCoursesMap.put(courseObj.Name, courseObj);
        }



        Map <String, List <recommendedCourse>> StudentAllCources = new Map <String, List <recommendedCourse>>();
        for (String student: StudentAllSkill.keySet()) {
            List <recommendedCourse> CourseList = new List<recommendedCourse>();
            for (String course: CourseAllSkill.keySet()) {
                recommendedCourse reccourse = new CourseAssignment.recommendedCourse();
                Decimal a = 0;
                List<Id> courseSkillsId = CourseAllSkill.get(course);
                List<Id> studentSkillsId = StudentAllSkill.get(student);
                    for (Id st: studentSkillsId) {
                        for (Id cr: courseSkillsId){
                            if (st == cr) {
                                a++;
                            }
                        }
                    }
                reccourse.percentCompliance = (a/courseSkillsId.size()*100).setScale(1);
                reccourse.course = AllCoursesMap.get(course);
                CourseList.add(reccourse);
            }
            StudentAllCources.put(student,CourseList);
        }
        return StudentAllCources;
    }

   public class recommendedCourse {
      public Decimal percentCompliance;
      public Course__c course;

//      public recommendedCourse(Course__c course, Integer compliance) {
//
//          this.course = course;
//          this.percentCompliance = compliance;
//
//      }
   }
}