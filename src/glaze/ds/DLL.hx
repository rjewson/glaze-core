package glaze.ds;

interface DLLNode<T>
{
    var prev:T;
    var next:T;
}

class DLL<T:(DLLNode<T>)>
{

    public var head:T;
    public var tail:T;

    public var length:Int;

    public function new() {
        length = 0;
    }

    //Linked List Functions
    public inline function insertAfter(node:T,newNode:T) {
        length++;
        newNode.prev = node;
        newNode.next = node.next;
        if (node.next==null)
            tail = newNode;
        else
            node.next.prev = newNode;
        node.next = newNode;
    }

    public inline function insertBefore(node:T,newNode:T) {
        length++;
        newNode.prev = node.prev;
        newNode.next = node;
        if (node.prev == null)
            head = newNode;
        else
            node.prev.next = newNode;
        node.prev = newNode;
    }

    public inline function insertBeginning(newNode:T) {
        if (head == null) {
            length++;
            head = newNode;
            tail = newNode;
            newNode.prev = null;
            newNode.next = null;
        } else  
            insertBefore(head, newNode);
     }

     public inline function insertEnd(newNode:T) {
        if (tail == null)
            insertBeginning(newNode);
        else
            insertAfter(tail, newNode);
     }

    public inline function remove(node:T):T {
        length--;
        var next = node.next;
        if (node.prev == null)
            head = node.next;
        else
            node.prev.next = node.next;
        if (node.next == null)
            tail = node.prev;
        else
            node.next.prev = node.prev;
        node.prev = node.next = null;
        return node;
    }

    //TODO Iterate,Sort

    public function sort(comparitor:T->T->Float) {
        if (length==0)
            return;

        var h:T = head;
        var n:T = h.next;

            while (n!=null) {
                var m = n.next;
                var p = n.prev;
                
                if (comparitor(n,p)<0) {

                    var i = p;
                    
                    while (i.prev!=null) {
                        if (comparitor(n,i.prev)<0)
                            i = i.prev;
                        else
                            break;
                    }
                    if (m!=null) {
                        p.next = m;
                        m.prev = p;
                    } else {
                        p.next = null;
                        tail = p;
                    }
                    
                    if (i == h) {
                        n.prev = null;
                        n.next = i;
                        
                        i.prev = n;
                        h = n;
                    } else {
                        n.prev = i.prev;
                        i.prev.next = n;
                        
                        n.next = i;
                        i.prev = n;
                    }
                }
                n = m;
            }
            head = h;
        }


}