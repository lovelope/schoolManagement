package com.studentsystem;
/**
 * 学生的javabean，用来保存和获取学生的各种信息，在其他类中与Arraylist<>使用
 * @version 1.0
 * @author LBJ
 */
public class Student {
  private String StudentNo;
  private String Name;
  private String CardNamber;
  private String Prince;
  private String Sex;
  private String Birthday;
  private String Phone;
  private String Subject;
  private String Class;
  private String Email;
  private String Academy;
  private float CourseGrade;
  public Student()
  {
	  
  }
  public String getStudentNo()
  {
	  return StudentNo;
  }
  public void setStudentNo(String studentno)
  {
	  this.StudentNo=studentno;
  }
  public String getName()
  {
	  return Name;
  }
  public void setName(String name)
  {
	  this.Name=name;
  } 
  public String getCardNamber()
  {
	  return CardNamber;
  }
  public void setCardNamber(String cardnamber)
  {
	  this.CardNamber=cardnamber;
  }
  public String getPrince()
  {
	  return Prince;
  }
  public void setPrince(String prince)
  {
	  this.Prince=prince;
  }
  public String getSex()
  {
	  return Sex;
  }
  public void setSex(String Sex)
  {
	  this.Sex=Sex;
  }
  public String getBirthday()
  {
	  return Birthday;
  }
  public void setBirthday(String Birthday)
  {
	  this.Birthday=Birthday;
  } 
  public String getPhone()
  {
	  return Phone;
  }
  public void setPhone(String Phone)
  {
	  this.Phone=Phone;
  } 
  public String getSubject()
  {
	  return Subject;
  }
  public void setSubject(String Subject)
  {
	  this.Subject=Subject;
  }
  public String getMyClass()
  {
	  return Class;
  }
  public void setClass(String Class)
  {
	  this.Class=Class;
  } 
  public String getEmail()
  {
	  return StudentNo;
  }
  public void setEmail(String Email)
  {
	  this.Email=Email;
  }
  public String getAcademy()
  {
	  return Academy;
  }
  public void setAcademy(String Academy)
  {
	  this.Academy=Academy;
  }
  public float getCourseGrade()
  {
	  return CourseGrade;
  }
  public void setCourseGrade(float CourseGrade)
  {
	  this.CourseGrade=CourseGrade;
  }
  
}
