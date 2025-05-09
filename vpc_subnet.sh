#!/bin/bash

# 10.0.0.0/16 CIDR을 가진 VPC 찾기
echo "10.0.0.0/16 CIDR을 가진 VPC 검색 중..."
vpc_id=$(aws ec2 describe-vpcs \
  --filters "Name=cidr-block,Values=10.0.0.0/16" \
  --query "Vpcs[0].VpcId" \
  --output text)

# VPC가 존재하는지 확인
if [ "$vpc_id" == "None" ] || [ -z "$vpc_id" ]; then
  echo "10.0.0.0/16 CIDR을 가진 VPC를 찾을 수 없습니다."
  exit 1
fi

echo "VPC ID: $vpc_id"

# 해당 VPC의 퍼블릭 서브넷 찾기
echo "퍼블릭 서브넷 검색 중..."
subnet_id=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$vpc_id" "Name=map-public-ip-on-launch,Values=true" \
  --query "Subnets[0].SubnetId" \
  --output text)

# 퍼블릭 서브넷이 존재하는지 확인
if [ "$subnet_id" == "None" ] || [ -z "$subnet_id" ]; then
  echo "해당 VPC에서 퍼블릭 서브넷을 찾을 수 없습니다."
  exit 1
fi

# 환경 변수로 설정 및 export
export DEFAULT_VPC_ID=$vpc_id
export PUBLIC_SUBNET_ID=$subnet_id"

# 환경 변수를 파일에 저장 (선택 사항)
echo "export DEFAULT_VPC_ID=$DEFAULT_VPC_ID" >> ~/.bashrc
echo "export PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID" >> ~/.bashrc

# 새로 설정된 환경 변수를 현재 셸에 적용
source ~/.bashrc

echo "환경 변수 설정이 완료되었습니다."
echo "DEFAULT_VPC_ID: $DEFAULT_VPC_ID"
echo "PUBLIC_SUBNET_ID: $PUBLIC_SUBNET_ID"
source ~/.bashrc
