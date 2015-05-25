package glaze.signals;

class SignalBase<TListener>
{
    public var head:ListenerNode<TListener>;
    public var tail:ListenerNode<TListener>;

    public var numListeners(default, null):Int;

    private var listenerNodePool:ListenerNodePool<TListener>;
    private var toAddHead:ListenerNode<TListener>;
    private var toAddTail:ListenerNode<TListener>;
    private var dispatching:Bool;

    public function new()
    {
        listenerNodePool = new ListenerNodePool();
        numListeners = 0;
    }

    private function startDispatch():Void
    {
        dispatching = true;
    }

    private function endDispatch():Void
    {
        dispatching = false;
        if (toAddHead != null)
        {
            if (head == null)
            {
                head = toAddHead;
                tail = toAddTail;
            }
            else
            {
                tail.next = toAddHead;
                toAddHead.previous = tail;
                tail = toAddTail;
            }
            toAddHead = null;
            toAddTail = null;
        }
        listenerNodePool.releaseCache();
    }

    private inline function getNode(listener:TListener):ListenerNode<TListener>
    {
        var node:ListenerNode<TListener> = head;
        while (node != null)
        {
            if (Reflect.compareMethods(node.listener, listener))
                break;
            node = node.next;
        }

        if (node == null)
        {
            node = toAddHead;
            while (node != null)
            {
                if (Reflect.compareMethods(node.listener, listener))
                    break;
                node = node.next;
            }
        }

        return node;
    }

    private inline function nodeExists(listener:TListener):Bool
    {
        return getNode(listener) != null;
    }

    public function add(listener:TListener):Void
    {
        if (nodeExists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        addNode(node);
    }

    public function addOnce(listener:TListener):Void
    {
        if (nodeExists(listener))
            return;

        var node:ListenerNode<TListener> = listenerNodePool.get();
        node.listener = listener;
        node.once = true;
        addNode(node);
    }

    private function addNode(node:ListenerNode<TListener>):Void
    {
        if (dispatching)
        {
            if (toAddHead == null)
            {
                toAddHead = toAddTail = node;
            }
            else
            {
                toAddTail.next = node;
                node.previous = toAddTail;
                toAddTail = node;
            }
        }
        else
        {
            if (head == null)
            {
                head = tail = node;
            }
            else
            {
                tail.next = node;
                node.previous = tail;
                tail = node;
            }
        }
        numListeners++;
    }

    public function remove(listener:TListener):Void
    {
        var node:ListenerNode<TListener> = getNode(listener);
        if (node != null)
        {
            if (head == node)
                head = head.next;
            if (tail == node)
                tail = tail.previous;
            if (toAddHead == node)
                toAddHead = toAddHead.next;
            if (toAddTail == node)
                toAddTail = toAddTail.previous;
            if (node.previous != null)
                node.previous.next = node.next;
            if (node.next != null)
                node.next.previous = node.previous;

            if (dispatching)
                listenerNodePool.cache(node);
            else
                listenerNodePool.dispose(node);

            numListeners--;
        }
    }

    public function removeAll():Void
    {
        while (head != null)
        {
            var node:ListenerNode<TListener> = head;
            head = head.next;
            listenerNodePool.dispose(node);
        }
        tail = null;
        toAddHead = null;
        toAddTail = null;
        numListeners = 0;
    }
}
