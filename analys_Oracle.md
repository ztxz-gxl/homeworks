# **作业**

1. **选做题**

   oracle.sol：

   ```solidity
   pragma solidity ^0.6.0;
    //区块链检查点注册器的实现
   
   contract CheckpointOracle {
       //事件
   
       // 当新的检查点建议收到时，将发出NewCheckpointVote事件
       event NewCheckpointVote(uint64 indexed index, bytes32 checkpointHash, uint8 v, bytes32 r, bytes32 s);
   
       //公开方法
       constructor(address[] memory _adminlist, uint _sectionSize, uint _processConfirms, uint _threshold) public {
           for (uint i = 0; i < _adminlist.length; i++) {
               admins[_adminlist[i]] = true;
               adminList.push(_adminlist[i]);
           }
           sectionSize = _sectionSize;
           processConfirms = _processConfirms;
           threshold = _threshold;
       }
   
       /**
        获取最新稳定的检查点信息.
        返回 截面索引，返回 检查点哈希，返回 与检查点关联的块高度
        */
       function GetLatestCheckpoint()
       view
       public
       returns(uint64, bytes32, uint) {
           return (sectionIndex, hash, height);
       }
   
       // SetCheckpoint设置新检查点。它接受签名列表
       // @_recentNumber: 最近的区块头，用于重播保护
       function SetCheckpoint(
           uint _recentNumber,
           bytes32 _recentHash,
           bytes32 _hash,
           uint64 _sectionIndex,
           uint8[] memory v,
           bytes32[] memory r,
           bytes32[] memory s)
           public
           returns (bool)
       {
           // 确保发件人获得授权
           require(admins[msg.sender]);
   
           // 这些检查重放保护，因此不能在fork上重放,
           // 意外地或故意地
           require(blockhash(_recentNumber) == _recentHash);
   
           // 确保批签名有效.
           require(v.length == r.length);
           require(v.length == s.length);
   
           // 过滤掉“未来”检查点.
           if (block.number < (_sectionIndex+1)*sectionSize+processConfirms) {
               return false;
           }
           // 过滤掉“旧”公告
           if (_sectionIndex < sectionIndex) {
               return false;
           }
           // 过滤掉“过时”的公告
           if (_sectionIndex == sectionIndex && (_sectionIndex != 0 || height != 0)) {
               return false;
           }
           // 筛选出“无效”公告
           if (_hash == ""){
               return false;
           }
   
           // 计算要验证的哈希时的参数
           bytes32 signedHash = keccak256(abi.encodePacked(byte(0x19), byte(0), this, _sectionIndex, _hash));
   
           address lastVoter = address(0);
   
           // 为了让我们不必保持一个谁已经投票，我们不想数到两次，签名必须严格按顺序提交
           for (uint idx = 0; idx < v.length; idx++){
               address signer = ecrecover(signedHash, v[idx], r[idx], s[idx]);
               require(admins[signer]);
               require(uint256(signer) > uint256(lastVoter));
               lastVoter = signer;
               emit NewCheckpointVote(_sectionIndex, _hash, v[idx], r[idx], s[idx]);
   
               // 存在足够的签名，更新最新的检查点。
               if (idx+1 >= threshold){
                   hash = _hash;
                   height = block.number;
                   sectionIndex = _sectionIndex;
                   return true;
               }
           }
           // 我们不应该在这里结束，恢复un-emits事件
           revert();
       }
   
       /**
        获取所有管理员地址 ， 返回地址集合
        */
       function GetAllAdmin()
       public
       view
       returns(address[] memory)
       {
           address[] memory ret = new address[](adminList.length);
           for (uint i = 0; i < adminList.length; i++) {
               ret[i] = adminList[i];
           }
           return ret;
       }
       
       // 有权更新CHT和bloom Trie root的管理员用户的地图 root
       mapping(address => bool) admins;
   
       // 管理员用户列表，以便我们可以获得所有管理员用户.
       address[] adminList;
   
       // 最新存储的节id
       uint64 sectionIndex;
   
       // 与最新注册的检查点关联的块高度.
       uint height;
   
       // 最新注册的检查点的哈希.
       bytes32 hash;
   
       // 创建检查点的频率
       // 默认值应与以太坊中的检查点大小（32768）相同。
       uint sectionSize;
   
       // 注册检查点之前所需的确认数。我们必须确保注册的检查点不会因为链重组.默认值应与检查点进程相同 confirmations(256)，in the ethereum.
       uint processConfirms;
   
       // 完成稳定检查点所需的签名.
       uint threshold;
   }
   
   ```

