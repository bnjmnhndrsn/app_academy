var Cat = function(name, owner) {
  this.name = name;
  this.owner = owner;
};

Cat.prototype.cuteStatement = function() {
  return this.owner + " loves " + this.name;
}

var gizmo = new Cat("Gizmo", "John");

var Student = function(firstName, lastName) {
  this.firstName = firstName;
  this.lastName = lastName;
  this.courses = [];
}

Student.prototype.name = function() {
  return this.firstName + " " + this.lastName;
}

Student.prototype.enroll = function(newCourse) {
  if (this.hasConflict(newCourse)) {
    throw "Scheduling Conflict!";
  } else {
    this.courses.push(newCourse);
    newCourse.students.push(this);
  }
  
  return this.courses;
}

Student.prototype.hasConflict = function(newCourse) {
  return this.courses.some( function(studentCourse) {
    return studentCourse.conflictsWith(newCourse);
  });
}

var Course = function(name, dept, credits, days, block) {
  this.name = name;
  this.dept = dept;
  this.credits = credits;
  this.days = days;
  this.block = block;
  this.students = [];
}

Course.prototype.addStudent = function(student) {
  student.enroll(this);
}

Course.prototype.conflictsWith = function(course) {
  var conflicting = false;
  if (this.block === course.block) {
    this.days.forEach( function(day) {
      if (course.days.indexOf(day) !== -1) {
        conflicting = true;
      }
      
    });
  }
  
  return conflicting;
}


duncan = new Student("Duncan", "Skinner")
bio = new Course("bio101", "Biology", 3, ["mon","wed"], 5)
chem = new Course("chem103", "Chemistry", 4, ["mon", "thurs", "fri"], 5)