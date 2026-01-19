def get_input(n):
    list = []
    for i in range(n):
        a = int(input(f"Enter number {i}: "))
        list.append(a)
    return list

def selection_sort(arr):
    n = len(arr)
    for j in range(n):
        min_ind = j
        for i in range(j+1,n):
            if(arr[i]<arr[min_ind]):
                min_ind = i
        arr[j],arr[min_ind] = arr[min_ind],arr[j]
    return arr

if __name__ == "__main__":
    n = int(input("Enter number of elements: "))
    arr = get_input(n)
    sorted_arr = selection_sort(arr)
    print("Sorted array is:", sorted_arr)        