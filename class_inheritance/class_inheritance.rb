require "byebug"
class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  def bonus(multiplier)
    sub_salaries = 0
    # debugger
    sub_employees.each do |employee|
      sub_salaries += employee.salary
    end

    sub_salaries * multiplier
  end

  def sub_employees
    res = []
    employees.each do |employee|
      if employee.is_a?(Manager)
        res << employee
        res += employee.sub_employees
      else
        res << employee
      end
    end

    res
  end
end

ned = Manager.new("Ned", "Founder", 1_000_000, nil)
darren = Manager.new("Darren", "TA Manager", 78_000, ned)
shawna = Employee.new("Shawna", "TA", 12_000, darren)
david = Employee.new("David", "TA", 10_000, darren)

ned.employees << darren
darren.employees << shawna
darren.employees << david


puts ned.bonus(5)
puts darren.bonus(4)
puts david.bonus(3)
