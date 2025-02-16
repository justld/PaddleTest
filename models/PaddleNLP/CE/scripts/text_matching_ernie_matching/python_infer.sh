#unset http_proxy
HTTPPROXY=$http_proxy
HTTPSPROXY=$https_proxy
unset http_proxy
unset https_proxy

#外部传入参数说明
# $1:  $XPU = gpu or cpu
#获取当前路径
cur_path=`pwd`
model_name=${PWD##*/}

echo "$model_name 模型训练阶段"

#路径配置
root_path=$cur_path/../../
code_path=$cur_path/../../models_repo/examples/text_matching/ernie_matching/
log_path=$root_path/log/$model_name/

if [ ! -d $log_path ]; then
  mkdir -p $log_path
fi

print_info(){
if [ $1 -ne 0 ];then
    cat ${log_path}/$2.log
    echo "exit_code: 1.0" >> ${log_path}/$2.log
else
    echo "exit_code: 0.0" >> ${log_path}/$2.log
fi
}

#访问RD程序
cd $code_path

python export_model.py --params_path ./checkpoints/$3/single/model_1000/model_state.pdparams --output_path=./output_$3
python deploy/python/predict.py --model_dir ./output_$3 --device $1 > $log_path/python_infer_$3_$1.log 2>&1

print_info $? python_infer_$3_$1

#set http_proxy
export http_proxy=$HTTPPROXY
export https_proxy=$HTTPSPROXY
