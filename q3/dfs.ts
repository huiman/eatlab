class TreeNode {
  value: number;
  left: TreeNode | null;
  right: TreeNode | null;

  constructor(value: number) {
    this.value = value;
    this.left = null;
    this.right = null;
  }
}

class Tree {
  root: TreeNode | null;

  constructor() {
    this.root = null;
  }

  static dfsFactory(method: "preorder" | "inorder" | "postorder") {
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
  }
}

class PreorderDFS {
  execute(root: TreeNode): number[] {
    const result: number[] = [];
    if (root !== null) {
      result.push(root.value);
      result.push(...this.execute(root.left!));
      result.push(...this.execute(root.right!));
    }
    return result;
  }
}

class InorderDFS {
  execute(root: TreeNode): number[] {
    const result: number[] = [];
    if (root !== null) {
      result.push(...this.execute(root.left!));
      result.push(root.value);
      result.push(...this.execute(root.right!));
    }
    return result;
  }
}

class PostorderDFS {
  execute(root: TreeNode): number[] {
    const result: number[] = [];
    if (root !== null) {
      result.push(...this.execute(root.left!));
      result.push(...this.execute(root.right!));
      result.push(root.value);
    }
    return result;
  }
}

const tree = new Tree();
tree.root = new TreeNode(1);
tree.root.left = new TreeNode(2);
tree.root.right = new TreeNode(3);
tree.root.left.left = new TreeNode(4);
tree.root.left.right = new TreeNode(5);
tree.root.left.right.left = new TreeNode(6);
tree.root.left.right.right = new TreeNode(7);
tree.root.left.right.right.left = new TreeNode(8);

const dfs_pre = Tree.dfsFactory("preorder");
const result_pre = dfs_pre.execute(tree.root);
console.log(result_pre);
const dfs_post = Tree.dfsFactory("postorder");
const result_post = dfs_post.execute(tree.root);
console.log(result_post);
const dfs_in = Tree.dfsFactory("inorder");
const result_in = dfs_in.execute(tree.root);
console.log(result_in);
