// Fatma Erem Aksoy -2315075

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthreads.h>


typedef struct Node {   // linked list implementation
    int data;
    struct Node* next;
} Node;


Node* newNode(int);
Node* readFile(char*);
int readLines(char*);
void insertNode(Node**, int);
void printContent(Node*, char*);
void selectionSort(Node*);
void readSort(char*);
int factorial(int);
void readCheck(char*);
void printArray(int*, int);


int main() {
    char input[20];
    char* filename = input;
    printf("Enter a file name to read from: ");
    scanf("%s", filename);

    pthread_t sort_thread, check_thread;

    // Creating threads
    pthread_create(&sort_thread, NULL, readSort, NULL);
    pthread_create(&check_thread, NULL, readCheck, NULL);

    // Waiting for threads to finish
    pthread_join(sort_thread, NULL);
    pthread_join(check_thread, NULL);

    // Free memory
    struct Node* current = head;
    while (current != NULL) {
        struct Node* temp = current;
        current = current->next;
        free(temp);
    }
    
    free(factorials);

    return 0;

}


Node* newNode(int data) {   // creating a new node with the data read from the entered file
    Node* N = (Node*)malloc(sizeof(Node));
    N->data = data;
    N->next = NULL;
    return N;
}


Node* readFile(char* filename) {
    int data;
    FILE* file = fopen(filename, "r");  // opening the file entered to read the data in it

    if (file == NULL) { // giving an error if the file entered is not found
        printf("Opening file '%s' is not successful!\n", filename);
        exit(1);
    }

    Node* head = NULL;
    while (fscanf(file, "%d", &data) != EOF) {      // reading the file till the end of file
        insertNode(&head, data);
    }

    fclose(file);       // closing the file as we are done with it
    return head;    // returning the last version of the linked list
}


int readLines(char* filename) {
    int counter = 0;
    char lineEnd;
    FILE* file = fopen(filename, "r");
    if(file == NULL) {
        printf("Reading file '%s' is not successful!\n", filename);
        exit(1);  }

    while ((lineEnd=fgetc(file)) != EOF) {
        if (lineEnd == '\n') {  // increasing the counter for each line
            counter++;    }
    }
    counter++;  // increasing again for the last line as well

    fclose(file);
    return counter;
}

void insertNode(Node** head, int data) {
    Node* N = newNode(data);     // defining a new node to add to the end of the linked list

    if (*head == NULL) {
        *head = N;
    }

    else {
        Node* last = *head;
        while (last->next != NULL) {    // continue checking if we are in the last node to insert the new one
            last = last->next;  }
        last->next = N;
    }
}


void printContent(Node* head, char* filename) {
    int counter;
    counter = readLines(filename) - 1;
    Node* N = head;
    printf("\nThe file %s is read and the sorted content of it is: \n", filename);
    printf("Sorting: ");
    while (N != NULL) {  // printing the data content of the last version of the list
        printf("%d", N->data);
        N = N->next;
        if (counter!=0)
            printf(" -> ");
        counter--;  }

    printf("\n");
}


void selectionSort(Node* head) {
    Node* temp1, *temp2, *min;
    for(temp1=head; temp1!=NULL; temp1=temp1->next) {   // checking the content if the data is at the correct position in the list (from lower to higher value)
        min = temp1;
        for(temp2=temp1->next; temp2!=NULL; temp2=temp2->next) {
            if(temp2->data < min->data) {
                min = temp2;    }   }

        if(min != temp1) {
            int temp = temp1->data;
            temp1->data = min->data;
            min->data = temp;   }
    }
}


void readSort(char* filename) {     // function to read values from a file, sort those values and print them
    Node* head = readFile(filename);
    selectionSort(head);
    printContent(head, filename);
}


int factorial(int n) {      // calculating the factorial of each number in the sorted linked list
    if(n<0){
        printf("Negative value is entered for n value, invalid!\n");
        return -1;  }
    else if(n==0)
        return 1;
    else
        return n * factorial(n - 1);
}


void readCheck(char* filename) {    // function to read numbers from a text file, sort them using the Selection Sort algorithm,
                                    // put them in a linked list and create an array with the factorial values of each number in the sorted linked list
    int i, arraySize, *array;
    Node* head = readFile(filename);
    arraySize = readLines(filename);
    selectionSort(head);

    array = (int*)malloc(arraySize*sizeof(int));
    if(array==NULL){
        printf("Memory allocation is failed!\n");
        return -1;  }

    Node* N = head;
    while(N!=NULL && i<arraySize) {
        array[i] = factorial(N->data);
        N = N->next;
        i++;    }
    printArray(array, arraySize);
}


void printArray(int* array, int size) {
    int i;
    printf("Factorial: ");
    for(i=0; i<size; i++) {
        printf("%d", array[i]);
        if(i!=(size-1)){
            printf(", ");}
    }
    printf("\n");
}






