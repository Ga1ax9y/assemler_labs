#include "IOSTREAM.H"
#include "STDIO.H"

struct Node
{
    short key;
    Node* left;
    Node* right;
    short height;
};

extern "C" short MAX(short a, short b);
extern "C" short TREE_HEIGHT(Node * node);
extern "C" short BALANCE(Node * node);
extern "C" Node * TOLEFT(Node * node);
extern "C" Node * TORIGHT(Node * node);
extern "C" Node * MINNODE(Node * node);
extern "C" Node * INSERTNODE(Node * node, short key);
extern "C" Node * DELETENODE(Node * node, short key);
extern "C" Node * SEARCHNODE(Node * node, short key);
extern "C" void FREETREE(Node * node);

extern "C" Node* new_node(short key)
{
    Node* node = new Node();
    node->key = key;
    node->left = 0;
    node->right = 0;
    node->height = 1;
    return node;
}

extern "C" void free_node(Node* node)
{
    delete node;
}

void pre_order(Node* node)
{
    if (node == 0) return;

    cout << '(' << node->key << ", " << node->height << ')' << ' ';
    pre_order(node->left);
    pre_order(node->right);
}

void in_order(Node* node)
{
    if (node == 0) return;

    in_order(node->left);
    cout << '(' << node->key << ", " << node->height << ')' << ' ';
    in_order(node->right);
}

void post_order(Node* node)
{
    if (node == 0) return;

    post_order(node->left);
    post_order(node->right);
    cout << '(' << node->key << ", " << node->height << ')' << ' ';
}

void in_order_write_file(Node* node, FILE* file)
{
    if (node == 0) return;

    in_order_write_file(node->left, file);
    fwrite(&(node->key), sizeof(short), 1, file);
    in_order_write_file(node->right, file);
}

void create_backup(Node* node)
{
    FILE* file = fopen("backup.bin", "w+");
    fclose(file);

    file = fopen("backup.bin", "wb+");
    in_order_write_file(node, file);
    fclose(file);
}

char load_backup(Node** node_ptr)
{
    FILE* file = fopen("backup.bin", "r+b");

    if (file == 0) return 1;

    FREETREE(*node_ptr);
    *node_ptr = 0;

    fseek(file, 0, 2);
    int size = ftell(file) / 2;
    fseek(file, 0, 0);

    short key = 0;
    for (int i = 0; i < size; i++)
    {
        fread(&key, sizeof(short), 1, file);
        *node_ptr = INSERTNODE(*node_ptr, key);
    }

    fclose(file);

    return 0;
}

int main()
{
    Node* root = 0;
    short command = 0;
    short key = 0;
    Node* temp = 0;

    while (1)
    {
        cout << "|--List of commands--|\n";
        cout << "1) Insert node\n";
	    cout << "2) Delete node\n";
	    cout << "3) Search node\n";
	    cout << "4) Check height\n";
	    cout << "5) Tree output\n";
	    cout << "6) New backup\n";
	    cout << "7) Load backup\n";
	    cout << "8) Exit\n\n";

        cout << "Choose command: ";
	    cin >> command;
        cout << "\n\n";

	    switch (command)
	    {
	        case 1:
		        cout << "[Insert] Enter key: ";
		        cin >> key;
		        root = INSERTNODE(root, key);
		    break;

            case 2:
                cout << "[Delete] Enter key: ";
                cin >> key;
                root = DELETENODE(root, key);
                break;

            case 3:
                cout << "[Search] Enter key: ";
                cin >> key;
                temp = SEARCHNODE(root, key);
                if (temp == 0) cout << "Key wasnt found\n";
                else cout << "Your key: " << key << "\nHeight: " << temp->height << '\n';
                break;

            case 4:
                cout << "[Height] Root height: " << root->height << '\n';
                break;

            case 5:
                cout << "[Output]\n";

                cout << "Preorder:\n";
                pre_order(root);

                cout << "\n\nInorder:\n";
                in_order(root);

                cout << "\n\nPostorder:\n";
                post_order(root);
                
                cout << '\n';
                break;

            case 6:
                create_backup(root);
                cout << "Saved!\n";
                break;

            case 7:
                if (load_backup(&root) == 1)
                {
                    cout << "There is no backup file \n";
                    break;
                }

                cout << "Loaded!\n";
                break;

            case 8:
                return 0;

            default:
                cout << "Wrong command, try again\n";
                break;
        }

        cout << "\n";
    }

    return 0;
}