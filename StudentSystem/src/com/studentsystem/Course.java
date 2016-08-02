package com.studentsystem;
/**
 * 课程的javabean,用来保存和提取课程的相关信息
 * @version 1.0
 * 
 */
public class Course {
    private String CourseNo;
    private String CourseName;
    private float StudyTime;
    private float Grade;
    private float Term;
    private String WhentoStudy;
    private float Result;
    private int StudentSum;
    private String Teachername;
    public Course()
    {}
    public String getCourseNo()
    {
    	return CourseNo;
    }
    public void setCourseNo(String courseno)
    {
    	this.CourseNo=courseno;
    }
    public String getCouresName()
    {
    	return CourseName;
    }
    public void setCourseName(String coursename)
    {
    	this.CourseName=coursename;
    }
    public float getStudyTime()
    {
    	return StudyTime;
    }
    public void setStudyTime(float studytime)
    {
    	this.StudyTime=studytime;

    }
    public float getGrade()
    {
    	return Grade; 
    }
    public void setGrade(float grade)
    {
    	this.Grade=grade;
    }
    public float getTerm()
    {
    	return Term;
    }
    public void setTerm(float term)
    {
    	this.Term=term;
    }
    public String getWhentoStudy()
    {
    	return WhentoStudy;
    }
    public void setWhentoStudy(String whentostudy)
    {
    	this.WhentoStudy=whentostudy;
    }
    public float getResult()
    {
    	return Result;
    }
    public void setResult(float result)
    {
    	this.Result=result;
    }
    public float getStudentSum()
    {
    	return StudentSum;
    }
    public void setStudentSum(int result)
    {
    	this.StudentSum=result;
    }
    public String getTeachername()
    {
    	return Teachername;
    }
    public void setTeachername(String result)
    {
    	this.Teachername=result;
    }
    
}
