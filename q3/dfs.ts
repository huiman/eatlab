class TreeNode<T> {
  value: T;
  left: TreeNode<T> | null;
  right: TreeNode<T> | null;

  constructor(value: T) {
    this.value = value;
    this.left = null;
    this.right = null;
  }
}

class Tree<T> {
  root: TreeNode<T> | null;

  constructor() {
    this.root = null;
  }

  static dfsFactory<T>(method: "preorder" | "inorder" | "postorder"): DFS<T> {
    switch (method) {
      case "preorder":
        return new PreorderDFS<T>();
      case "inorder":
        return new InorderDFS<T>();
      case "postorder":
        return new PostorderDFS<T>();
      default:
        throw new Error("Invalid traversal method specified");
    }
  }
}

interface DFS<T> {
  traverse(root: TreeNode<T>): T[];
}

// Define the PreorderDFS class
class PreorderDFS<T> implements DFS<T> {
  traverse(root: TreeNode<T>): T[] {
    const result: T[] = [];
    if (root !== null) {
      result.push(root.value);
      result.push(...this.traverse(root.left!));
      result.push(...this.traverse(root.right!));
    }
    return result;
  }
}

class InorderDFS<T> implements DFS<T> {
  traverse(root: TreeNode<T>): T[] {
    const result: T[] = [];
    if (root !== null) {
      result.push(...this.traverse(root.left!));
      result.push(root.value);
      result.push(...this.traverse(root.right!));
    }
    return result;
  }
}

class PostorderDFS<T> implements DFS<T> {
  traverse(root: TreeNode<T>): T[] {
    const result: T[] = [];
    if (root !== null) {
      result.push(...this.traverse(root.left!));
      result.push(...this.traverse(root.right!));
      result.push(root.value);
    }
    return result;
  }
}

// Example usage
const tree = new Tree<number>();
tree.root = new TreeNode(1);
tree.root.left = new TreeNode(2);
tree.root.right = new TreeNode(3);
tree.root.left.left = new TreeNode(4);
tree.root.left.right = new TreeNode(5);
tree.root.right.left = new TreeNode(6);
tree.root.right.right = new TreeNode(7);

const dfs_pre = Tree.dfsFactory("preorder");
const result_pre = dfs_pre.traverse(tree.root);
console.log(result_pre);
const dfs_post = Tree.dfsFactory("postorder");
const result_post = dfs_post.traverse(tree.root);
console.log(result_post);
const dfs_in = Tree.dfsFactory("inorder");
const result_in = dfs_in.traverse(tree.root);
console.log(result_in);
