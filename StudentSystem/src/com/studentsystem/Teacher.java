package com.studentsystem;
/**
 * 老师的javabean，保存和提取老师的相关信息
 * @version 1.0
 * @author Administrator
 */
public class Teacher {
  private String TeacherNo;
  private String TeacherName;
  private String Education;
  private String Professional;
  private String Phone;
  private String Email;
  private String Subject;
  public Teacher()
  {
	  
  }
  public  String getTeacherNo()
  {
	  return TeacherNo;
  }
  public void setTeacherNo(String TeacherNo)
  {
	  this.TeacherNo=TeacherNo;
  }
  public  String getTeacherName()
  {
	  return TeacherName;
  }
  public void setTeacherName(String TeacherName)
  {
	  this.TeacherName=TeacherName;
  }
  public  String getEducation()
  {
	  return Education;
  }
  public void setEducation(String Education)
  {
	  this.Education=Education;
  }
  public  String getProfessional()
  {
	  return Professional;
  }
  public void setProfessional(String Professional)
  {
	  this.Professional=Professional;
  }
  public  String getPhone()
  {
	  return Phone;
  }
  public void setPhone(String Phone)
  {
	  this.Phone=Phone;
  }
  public  String getEmail()
  {
	  return Email;
  }
  public void setEmail(String Email)
  {
	  this.Email=Email;
  }
  public  String getSubject()
  {
	  return Subject;
  }
  public void setSubject(String Subject)
  {
	  this.Subject=Subject;
  }
}
  
