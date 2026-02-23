#include <string>
#include <iostream>
#include <vector>
#include <set>
#include <algorithm>
#include <memory>
using namespace std;

/**
 * Airline scheduling
 *   1. Passenger
 *   2. Flight
 *   3. Flight manager
 **/

class Passenger
{
private:
    int phone = 0;
    string name;
    int age;
    int id;

public:
    Passenger() {}
    Passenger(int phone, string name, int age, int id) : phone(phone), age(age), id(id), name(name) {};
    int getId() const { return this->id; }
    string getName() const { return this->name; }
    void displayPassenger()
    {
        cout << "\nPassenger details: \n";
        cout << "-----------\n";
        cout << "Name\tAge\tPhone\n";
        cout << name << "\t" << age << "\t" << phone;
    }
};

class Flight
{
    vector<unique_ptr<Passenger>> passenger_list;
    int flight_id;
    string src, dst;
    string arrivalTime, departTime;
    int seats;
    int capacity = 120;

public:
    Flight()
    {
    }
    Flight(int id, string s, string d, int st)
        : flight_id(id), src(s), dst(d), seats(st) {}
    string getSource() const
    {
        return this->src;
    }

    string getDst() const
    {
        return this->dst;
    }

    string getarrivalTime() const
    {
        return this->arrivalTime;
    }

    string getdepartTime() const
    {
        return this->departTime;
    }

    void decrementSeat()
    {
        this->seats--;
        std::cout << "\n\nSeat booked successfully. \n\n";
    }

    void incrementSeat()
    {
        this->seats++;
        std::cout << "\n\nSeat cancelled successfully. \n\n";
    }

    bool bookSeat(unique_ptr<Passenger> p)
    {
        if (getSeats() <= 0)
            return false;

        passenger_list.push_back(move(p));
        decrementSeat();
        return true;
    }

    bool cancelSeatById(int id)
    {
        auto oldSize = passenger_list.size();

        passenger_list.erase(
            remove_if(passenger_list.begin(), passenger_list.end(),
                      [id](const std::unique_ptr<Passenger> &ptr)
                      {
                          return ptr->getId() == id;
                      }),
            passenger_list.end());

        if (passenger_list.size() == oldSize)
            return false;

        incrementSeat();
        return true;
    }

    int getSeats() const
    {
        return this->seats;
    }

    int getFlightById() const
    {
        return this->flight_id;
    }

    void displayFlights()
    {
        cout << "\nFlights on the " << flight_id << ": " << endl;
        for (unique_ptr<Passenger> &p : passenger_list)
        {
            // .get() method converts pointer to raw pointer
            p.get()->displayPassenger();
        }
    }
};

class Flight_manager
{
    /**
     * 3 primary types of smart pointers are used:
     *
     *      1. Unique_pointer: Enforces a one owner policy .
     *         Default choice for dynamically allocated plain old C++ objects (POCO) unless shared ownership is explicitly required .
     *
     *      2. Shared_pointer: Allow mutiple owners to share ownership of same object .
     *         It uses an internal reference count to track the number of owners .
     *         The object is deleted only when the last shared_ptr owner goes out of scope and the reference count reaches zero .
     *
     *      3. Weak pointer: A non-owning "observer" pointer that is used in conjunction with std::shared_ptr .
     *         It provides access to an object managed by a shared_ptr without contributing to the reference count .
     *         Its primary use is to break circular references that can occur between shared_ptr
     *         instances, which would otherwise prevent objects from being deleted .
     *
     **/
    vector<unique_ptr<Flight>> flights_available;
    set<int> present;
    static int n;

public:
    Flight_manager()
    {
        std::cout << "\n\n Flight booking system started!!!\n\n.";
    }

    void addFlight(unique_ptr<Flight> f)
    {
        if (f && f->getSeats() > 0)
        {
            present.insert(f->getFlightById());
            flights_available.push_back(std::move(f));
            n++;
        }
    }

    void displayFlights() const
    {
        if (flights_available.empty())
        {
            cout << "\nNo flights available.\n";
            return;
        }
        cout << "\nAvailable flights:\n";
        for (const auto &fp : flights_available)
        {
            cout << "Flight ID: " << fp->getFlightById()
                 << "  " << fp->getSource() << " -> " << fp->getDst()
                 << "  Seats left: " << fp->getSeats() << "\n";
        }
    }

    // helper used by passenger operations
    Flight *getFlightById(int id)
    {
        for (auto &fp : flights_available)
        {
            if (fp->getFlightById() == id)
                return fp.get();
        }
        return nullptr;
    }

    void cancelFlight(int flightId)
    {
        flights_available.erase(
            std::remove_if(flights_available.begin(), flights_available.end(),
                           [flightId](const std::unique_ptr<Flight> &ptr)
                           {
                               return ptr->getFlightById() == flightId;
                           }),
            flights_available.end());
        present.erase(flightId);
    }

    ~Flight_manager()
    {
        // * no need as unique pointer automatically handles manage lifetime of dynamically allocated memory.

        // for (Flight *f : flights_available)
        // {
        //     delete f;
        // }
        // flights_available.clear();
    }
};

class HandleOperations
{
    Flight_manager fm;
    /**
    Flight_manager
        owns → unique_ptr<Flight>

    Flight
        owns → unique_ptr<Passenger>

    Passenger
        owns nothing
    **/
    char isManager;

public:
    HandleOperations()
    {
        cout << "\nThank you for onboarding to this flight system.\nWe hope you get the best flight!!\n";
        cout << "Are you flight manager (no means you are a flight passenger manager) ? (y or n): ";
        cin >> isManager;
        if (isManager == 'y')
        {
            handleFlights();
        }
        else
            handlePassengers();
    }
    bool handleFlights()
    {
        int choice = 0;

        while (true)
        {
            cout << "\n--- Flight Manager Menu ---\n";
            cout << "1. Add Flight\n";
            cout << "2. Cancel Flight\n";
            cout << "3. Display All Flights\n";
            cout << "4. Exit\n";
            cout << "Enter choice: ";
            cin >> choice;

            if (choice == 1)
            {
                int id, seats;
                string src, dst;

                cout << "Enter Flight ID: ";
                cin >> id;
                cout << "Enter Source: ";
                cin >> src;
                cout << "Enter Destination: ";
                cin >> dst;
                cout << "Enter Number of Seats: ";
                cin >> seats;

                unique_ptr<Flight> newFlight = make_unique<Flight>(id, src, dst, seats);
                fm.addFlight(move(newFlight));

                cout << "Flight added successfully!\n";
            }
            else if (choice == 2)
            {
                int id;
                cout << "Enter Flight ID to cancel: ";
                cin >> id;

                fm.cancelFlight(id);
                cout << "Flight cancelled if it existed.\n";
            }
            else if (choice == 3)
            {
                fm.displayFlights();
            }
            else if (choice == 4)
            {
                cout << "Exiting Manager Menu...\n";
                return true;
            }
            else
            {
                cout << "Invalid choice.\n";
            }
        }
    }

    bool handlePassengers()
    {
        int choice = 0;

        while (true)
        {
            cout << "\n--- Passenger Menu ---\n";
            cout << "1. Book Seat\n";
            cout << "2. Cancel Seat\n";
            cout << "3. Display Passengers for a Flight\n";
            cout << "4. Exit\n";
            cout << "Enter choice: ";
            cin >> choice;

            if (choice == 1)
            {
                int flightId;
                cout << "Enter Flight ID: ";
                cin >> flightId;

                int phone, age, id;
                string name;

                cout << "Enter Passenger ID: ";
                cin >> id;
                cout << "Enter Name: ";
                cin >> name;
                cout << "Enter Age: ";
                cin >> age;
                cout << "Enter Phone: ";
                cin >> phone;

                unique_ptr<Passenger> p =
                    make_unique<Passenger>(phone, name, age, id);

                bool booked = false;
                Flight *flight = fm.getFlightById(flightId);
                if (flight)
                {
                    booked = flight->bookSeat(move(p));
                }

                if (!booked)
                    cout << "Booking failed (Flight not found or full).\n";
            }
            else if (choice == 2)
            {
                int flightId;
                int id;
                cout << "Enter Flight ID for cancellation: ";
                cin >> flightId;
                cout << "Enter Passenger ID to cancel: ";
                cin >> id;

                Flight *flight = fm.getFlightById(flightId);
                if (flight)
                {
                    if (!flight->cancelSeatById(id))
                        cout << "Passenger not found on that flight.\n";
                }
                else
                {
                    cout << "Flight not found.\n";
                }
            }
            else if (choice == 3)
            {
                int flightId;
                cout << "Enter Flight ID to view passengers: ";
                cin >> flightId;
                Flight *flight = fm.getFlightById(flightId);
                if (flight)
                {
                    flight->displayFlights();
                }
                else
                {
                    cout << "Flight not found.\n";
                }
            }
            else if (choice == 4)
            {
                cout << "Exiting Passenger Menu...\n";
                return true;
            }
            else
            {
                cout << "Invalid choice.\n";
            }
        }
    }
};

int Flight_manager::n = 0;

int main()
{
    HandleOperations flight_system;
    return 0;
}