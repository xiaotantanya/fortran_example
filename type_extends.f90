module m_employee
    implicit none
    private
    public t_date, t_address, t_person, t_employee

    type :: t_date
        integer :: year, month, day
    end type

    type :: t_address
        character(len=:), allocatable :: city, road_name
        integer :: house_number
    end type

    type, extends(t_address) :: t_person
        character(len=:), allocatable :: first_name, last_name, e_mail
    end type

    type, extends(t_person) :: t_employee
        type(t_date) :: hired_date
        character(len=:), allocatable :: position
        real :: monthly_salary
    end type

end module m_employee

program test_employee
    use m_employee
    implicit none
    type(t_employee) :: employee

    employee%hired_date%year = 2020
    employee%hired_date%month = 1
    employee%hired_date%day = 20

    employee%first_name = 'John'
    employee%last_name = 'Doe'

    employee%city = 'London'
    employee%road_name = 'BigBen'
    employee%house_number = 1

    employee%position = 'Intern'
    employee%monthly_salary = 0.0

end program test_employee

