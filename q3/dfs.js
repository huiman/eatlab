var TreeNode = /** @class */ (function () {
    function TreeNode(value) {
        this.value = value;
        this.left = null;
        this.right = null;
    }
    return TreeNode;
}());
var Tree = /** @class */ (function () {
    function Tree() {
        this.root = null;
    }
    Tree.dfsFactory = function (method) {
        switch (method) {
            case "preorder":
                return new PreorderDFS();
            case "inorder":
                return new InorderDFS();
            case "postorder":
                return new PostorderDFS();
            default:
                throw new Error("Invalid traversal method specified");
        }
    };
    return Tree;
}());
// Define the PreorderDFS class
var PreorderDFS = /** @class */ (function () {
    function PreorderDFS() {
    }
    PreorderDFS.prototype.traverse = function (root) {
        var result = [];
        if (root !== null) {
            result.push(root.value);
            result.push.apply(result, this.traverse(root.left));
            result.push.apply(result, this.traverse(root.right));
        }
        return result;
    };
    return PreorderDFS;
}());
var InorderDFS = /** @class */ (function () {
    function InorderDFS() {
    }
    InorderDFS.prototype.traverse = function (root) {
        var result = [];
        if (root !== null) {
            result.push.apply(result, this.traverse(root.left));
            result.push(root.value);
            result.push.apply(result, this.traverse(root.right));
        }
        return result;
    };
    return InorderDFS;
}());
var PostorderDFS = /** @class */ (function () {
    function PostorderDFS() {
    }
    PostorderDFS.prototype.traverse = function (root) {
        var result = [];
        if (root !== null) {
            result.push.apply(result, this.traverse(root.left));
            result.push.apply(result, this.traverse(root.right));
            result.push(root.value);
        }
        return result;
    };
    return PostorderDFS;
}());
// Example usage
var tree = new Tree();
tree.root = new TreeNode(1);
tree.root.left = new TreeNode(2);
tree.root.right = new TreeNode(3);
tree.root.left.left = new TreeNode(4);
tree.root.left.right = new TreeNode(5);
tree.root.right.left = new TreeNode(6);
tree.root.right.right = new TreeNode(7);
var dfs = Tree.dfsFactory("preorder");
var result = dfs.traverse(tree.root);
console.log(result);
